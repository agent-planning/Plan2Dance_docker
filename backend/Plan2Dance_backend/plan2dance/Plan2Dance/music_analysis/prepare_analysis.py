"""
    生成分类器
"""
from pyAudioAnalysis.MidTermFeatures import directory_feature_extraction as dw
from pyAudioAnalysis.MidTermFeatures import multiple_directory_feature_extraction as dws
from pyAudioAnalysis.audioTrainTest import normalize_features
from pyAudioAnalysis.audioBasicIO import read_audio_file, stereo_to_mono
from pyAudioAnalysis.MidTermFeatures import mid_feature_extraction, beat_extraction
import numpy as np
from sklearn.cluster import KMeans, SpectralClustering
import plotly as py
import plotly.graph_objs as go
import matplotlib.pyplot as plt
import pickle
import time
import os
import pandas as pd
from math import floor, ceil
import xml.dom.minidom
from pydub import AudioSegment
import shutil
import copy
from plan2dance.Plan2Dance.config import IOConfig
from plan2dance.Plan2Dance.common import ProjectPath


class MusicAnalysis:
    """
    -----------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------音频分类---------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------
    思路：
    1、对已有的音乐进行聚类训练生成模型：clster_for_music，可以选择模型使用或重新生成模型：choose_the_model_use
    2、解析舞蹈文件生成文件中动作时序关系：solve_the_action
    3、再一次对已有音乐进行预测，根据步骤2得到的动作时序关系对应到分类信息，给动作归类：__generate_action_type_csv（数据集太小）
    4、总合所有的已有音乐预测结果生成csv文件：concat_data_frame
    其他：
    绘制分类图：plot_charts_for_label
    提取音频特征：file_wav_feature_extraction
    根据模型预测音频结果：predict_result
    """

    def __init__(self):
        self.config = IOConfig().get_config()
        self.mt = float(self.config['mt'])
        self.st = float(self.config['st'])
        self.csv_col = self.__get_type()  # 列名
        self.relation_csv_path = os.path.join(ProjectPath, "Data/Train/MusicActionRelation")
        self.music_action_path = os.path.join(ProjectPath, "Data/Train/MusicAction")
        self.train_music_path = os.path.join(ProjectPath, 'Data/Train/Music')
        self.temporary_dir = os.path.join(self.train_music_path, 'temporary')
        self.model_save_path = os.path.join(ProjectPath, 'Data/Result/Model')
        self.cluster_csv = os.path.join(ProjectPath, 'Data/Train/action_type.csv')
        self.compute_beat = False

    def __get_type(self):
        if 'cluster-count' in self.config:
            cluster_count = int(self.config['cluster-count'])
            type_list = ['action']
            for i in range(cluster_count):
                type_list.append('type_' + str(i))
            return type_list

    @staticmethod
    def __plot_charts_for_label(data, save_name, title_str='', plot_type='pie', auto_open=True):
        """
        根据标签输出图形
        :param data: 标签
        :param save_name: 名字
        :param title_str: 标题
        :param plot_type: 'pie' or 'bar'
        :param auto_open: 自动打开
        :return:
        """

        def _get_color_combinations(n_classes):
            """获取随机颜色"""
            clr_map = plt.cm.get_cmap('jet')
            range_cl = range(int(int(255 / n_classes) / 2), 255, int(255 / n_classes))
            clr = []
            for i in range(n_classes):
                clr.append('rgba({},{},{},{})'.format(clr_map(range_cl[i])[0],
                                                      clr_map(range_cl[i])[1],
                                                      clr_map(range_cl[i])[2],
                                                      clr_map(range_cl[i])[3]))
            return clr

        data = sorted(data)
        unique_data = np.unique(data)
        # print(unique_data)
        values = []
        labels = []
        for ii in unique_data:
            labels.append('类型_{}'.format(ii + 1))
            values.append(data.count(ii))

        # print(values)
        data_g = []
        if plot_type == 'pie':
            trace = go.Pie(labels=labels, values=values)
            data_g.append(trace)
            layout = go.Layout(title="{}".format(title_str))
            fig = go.Figure(data=data_g, layout=layout)
            py.offline.plot(fig, filename=save_name, auto_open=auto_open)
        elif plot_type == 'bar':
            colors = _get_color_combinations(len(unique_data))
            data = [go.Bar(x=labels, y=values, marker=dict(color=colors))]
            layout = go.Layout(title="{}".format(title_str),
                               xaxis={'title': '类型'}, yaxis={'title': '数量'})

            fig = go.Figure(data=data, layout=layout)
            py.offline.plot(fig, filename=save_name, auto_open=auto_open)

    def __temporary_cutting_train_music(self, action_ductive_time):
        # 新建临时文件夹
        if not os.path.exists(self.temporary_dir):
            os.mkdir(self.temporary_dir)
        temporary = 0
        for action in action_ductive_time:
            music_name = os.path.join(self.train_music_path, action + '.mp3', )
            audiofile = AudioSegment.from_file(music_name, 'mp3')
            for durative in action_ductive_time[action]:
                filename = os.path.join(self.temporary_dir, 'temporary-{}.wav'.format(temporary))
                audiofile[durative[0] * 1000:durative[1] * 1000].export(filename, format="wav")
                print("Cut out the audio from {0} ==>{1}".format(action, filename))
                temporary += 1
        # 循环relation的文件夹拿到每个的文件，然后找到在music中对应的文件

    def cluster_for_music(self, train_path, mt_win, mt_step, st_win, st_step, n_clusters=3,
                          model_name='k-mean',
                          compute_beat=False, is_dir=True):
        """
        This is a cluster for music. It will save train model depend on the training date.

        #  特征的数量均由step决定，st根据信号量决定循环次数N，而st_step决定最后特征列号M为N/(st_step * FS )
        #  mt根据st返回特征的列号M决定外部循环次数M，而mt_step决定最后循环总次数为
        #  st_step 表示st每次循环cur_p += step， 但是st_win 的窗口表示每次所计算出的信号范围[cur_p,cur_p + win]，所以如果想分段获取，那么step和win的数值应相等
        #  输出聚类标签到excel文件，保存标签数组到文本文件
        #  模型最终效果：输入音频文件，返回音频类型
        #  分割器的需求，输入音乐，进行分割

        :param train_path: The path of TrainSet
        :param st_step: short-term step
        :param st_win: short-term win
        :param mt_step: mid-term step
        :param mt_win: mid-term win
        :param n_clusters: Ended up Cluster. The part of the TrainSet.
        :param model_name: k-mean, spectral_clustering
        :param compute_beat: whether increase the beat to the features set
        :param is_dir: 'train_path' is a dir or dirs
        :return: Save model Name
        """
        # 提取特征
        if is_dir:
            f, fn, feature_names = dw(train_path, mt_win, mt_step, st_win, st_step, compute_beat=compute_beat)
        else:
            f, cn, fn, feature_names = dws(train_path, mt_win, mt_step, st_win, st_step, compute_beat=compute_beat)
        (mt_feats_norm, MEAN, STD) = normalize_features([f])
        # self.train_music_features = f
        # 训练模型
        if model_name == 'k-mean':
            model = KMeans(n_clusters=n_clusters)
            model.fit(mt_feats_norm[0])
        elif model_name == 'spectralClustering':
            model = SpectralClustering(n_clusters=n_clusters)
            model.fit(mt_feats_norm[0])
        else:
            raise Exception("此训练方法不存在")

        # 保存模型
        # 获取日期
        local = time.localtime()
        timestramp = int(time.time())
        year_path = os.path.join(self.model_save_path, str(local.tm_year))
        year_mon_path = os.path.join(year_path, str(local.tm_mon))
        year_mon_day_path = os.path.join(year_mon_path, str(local.tm_mday))
        for i in (year_path, year_mon_path, year_mon_day_path):
            if not os.path.exists(i):
                os.mkdir(i)
                print("Create Directory {}".format(i))
            else:
                print("Directory {} Exist!!!".format(i))

        save_path = os.path.join(year_mon_day_path, str(timestramp))
        os.mkdir(save_path)
        print(save_path)
        save_model_name = os.path.join(save_path, '{}_{}_{}.pickle'.format(model_name, n_clusters, timestramp))
        with open(save_model_name, 'wb') as f:
            pickle.dump(model, f)
            print("!!!Classifier OK. Path: {}".format(save_model_name))

        # 绘图
        mlb = model.labels_
        plot_type = 'pie'
        plot_name = '{}_{}_{}_{}'.format(model_name, n_clusters, plot_type, timestramp)
        save_name = os.path.join(save_path, plot_name + '.html')
        self.__plot_charts_for_label(mlb, save_name, plot_name, plot_type)  # 输出聚类各类型的占比 柱 形图或饼图
        print("Visualization O. Path: {}".format(save_name))

        return save_model_name

    @staticmethod
    def file_wav_feature_extraction(file_name, mt_win, mt_step, st_win, st_step,
                                    compute_beat=False):
        """
        This function extracts the mid-term features of the WAVE files .

        The resulting feature vector is extracted by long-term averaging the mid-term features.
        Therefore ONE FEATURE VECTOR is extracted for each WAV file.

        ARGUMENTS:
            - fileName:        the path of the WAVE
            - mt_win, mt_step:    mid-term window and step (in seconds)
            - st_win, st_step:    short-term window and step (in seconds)
        """

        all_mt_feats = np.array([])

        print("Analyzing file name {}".format(file_name))

        if os.stat(file_name).st_size == 0:
            print("   (EMPTY FILE -- SKIPPING)")
            return
        [fs, x] = read_audio_file(file_name)
        if isinstance(x, int):
            return

        t1 = time.clock()
        x = stereo_to_mono(x)  # 将双声道或立体声的信号转为单声道，声道可以说是录制时候的音源数量问题
        if x.shape[0] < float(fs) / 5:
            print("  (AUDIO FILE TOO SMALL - SKIPPING)")
            return
        if compute_beat:  # fs（采样率） 每秒获取的信号 举例：一段音频10s，采样率为8000，即是1s的音频用8000信号单元表示
            [mt_term_feats, st_features, mt_feature_names] = mid_feature_extraction(x, fs, round(mt_win * fs),
                                                                                    round(mt_step * fs),
                                                                                    round(fs * st_win),
                                                                                    round(fs * st_step))
            mt_win_ratio = int(round(mt_win / st_step))
            mt_step_ratio = int(round(mt_step / st_step))
            beat_list, beat_conf_list = [], []
            cur_p = 0
            N = len(st_features[1])
            while (cur_p < N):
                N1 = cur_p
                N2 = cur_p + mt_win_ratio
                if N2 > N:
                    N2 = N
                cur_st_features = st_features[:, N1:N2]
                [beat, beat_conf] = beat_extraction(cur_st_features, st_step)
                if np.isnan(beat):
                    beat_conf = beat_list[-1]
                if np.isnan(beat_conf):
                    beat_conf = beat_conf_list[-1]
                beat_list.append(beat)
                beat_conf_list.append(beat_conf)
                cur_p += mt_step_ratio

            mt_term_feats = np.append(mt_term_feats, [beat_list], axis=0)
            mt_term_feats = np.append(mt_term_feats, [beat_conf_list], axis=0)
        else:
            [mt_term_feats, _, mt_feature_names] = mid_feature_extraction(x, fs, round(mt_win * fs),
                                                                          round(mt_step * fs),
                                                                          round(fs * st_win), round(fs * st_step))

        mt_term_feats = np.transpose(mt_term_feats)  # 转置矩阵
        # long term averaging of mid-term statistics
        if (not np.isnan(mt_term_feats).any()) and (not np.isinf(mt_term_feats).any()):
            all_mt_feats = mt_term_feats
            t2 = time.clock()
            duration = float(len(x)) / fs
            print("Music duration time: ", duration, ' s')
            # if len(process_times) > 0:
            print("Feature extraction complexity ratio: "
                  "{0:.1f} x realtime".format((1.0 / np.mean(np.array((t2 - t1) / duration)))))
        return (all_mt_feats, mt_feature_names)

    def predict_result(self, model_name, music_name):
        mt, st = self.mt, self.st
        all_mt_feats, _ = self.file_wav_feature_extraction(music_name, mt, mt, st, st, compute_beat=self.compute_beat)
        (mt_feats_norm, MEAN, STD) = normalize_features([all_mt_feats])
        predict_data = mt_feats_norm[0]
        cluster_method = self.config['cluster-method']
        with open(model_name, 'rb') as f:
            clf = pickle.load(f)
            if cluster_method == 'k-mean':
                result = clf.predict(predict_data)
            elif cluster_method == 'spectralClustering':
                result = clf.fit_predict(predict_data)
        return result

    @staticmethod
    def get_lastly_model():
        file_dir = os.path.join(ProjectPath, 'Data/Result/Model/2020')
        path = file_dir
        for i in range(4):
            dir_list = os.listdir(path)
            if i == 3:
                dir_list.sort(key=lambda x: ord(x.split('.')[1][0]))
                path = os.path.join(path, dir_list[-1])
                break
            dir_list.sort(key=lambda x: int(x))
            path = os.path.join(path, dir_list[-1])

        return path

    @staticmethod
    def _get_music_time(music_path):
        """
        获取当前分析音乐的时长
        :return:
        """
        [fs, x] = read_audio_file(music_path)
        duration = float(len(x)) / fs
        return duration

    def choose_model(self, action_duration_time, is_restart=False):
        """
        选择是否重新生成模型
        :param action_duration_time:
        :param is_restart: False
        :return: 返回模型预测结果
        """

        cluster_count = int(self.config['cluster-count'])
        cluster_method = self.config['cluster-method']
        mt = self.mt
        st = self.st
        if not is_restart:
            print("Use existing models!!!")
            return self.get_lastly_model()
        else:
            print("Rebuild model!!!")
            self.__temporary_cutting_train_music(action_duration_time)  # 切割音频作训练
            model_name = self.cluster_for_music(self.temporary_dir, mt, mt, st, st, cluster_count, cluster_method,
                                                self.compute_beat)
            if os.path.exists(self.temporary_dir):
                shutil.rmtree(self.temporary_dir)
            return model_name

    def __generate_signal_action_type(self, music_name, result):
        """
        从音频分类信息中找到动作文件对应的类型
        :param music_name: 音乐名字
        :param result: 分类结果
        :return: csv文件
        """
        music_name = music_name.split(".")[0]
        action_info = pd.read_csv(os.path.join(self.relation_csv_path, music_name + ".csv"))
        # 1、拿到最后一个end_time
        current_action_all_time = action_info["end_time"].values[-1]
        # 2、作为下标取值
        current_col = copy.copy(self.csv_col)
        current_col.append('probability')
        action_csv = pd.DataFrame([], columns=current_col)  # 初始化DataFrame
        for index, row in action_info.iterrows():
            action_name = row["action"].replace(" ", "")  # 动作名字
            start_time = row["start_time"]  # 动作开始时间
            end_time = row["end_time"]  # 动作结束时间
            start_index = floor(start_time * (len(result) / current_action_all_time))
            end_index = ceil(end_time * (len(result) / current_action_all_time)) - 1
            if end_index - start_index < 1:  # 防止数值相同取值为空
                end_index = start_index + 1
            index_tuple = result[start_index:end_index]
            # print(action_name, "  ==> start_time：", start_index, "end_time：", end_index)
            index_set = set(index_tuple)
            # 3、判断区间内最多的数字，保存动作名字对应的类型 不可重复
            # max_num = np.argmax(np.bincount(index_list))  # 当前这个区间出现最多的是
            # 存储最后的数据
            for num in index_set:
                column_type = "type_" + str(num)
                if action_name in action_csv["action"].values:  # 已存在，类型+1
                    action_csv.loc[action_csv["action"] == action_name, column_type] += 1
                else:  # 不存在
                    arr = []  # 行信息
                    for col in action_csv.columns.values.tolist():
                        if column_type == col:
                            arr.append(1)
                        elif col == 'probability':
                            arr.append(1)  # 概率默认为1
                        else:
                            arr.append(0)
                    arr[0] = action_name
                    current_frame = pd.DataFrame([arr], columns=current_col)
                    action_csv = action_csv.append(current_frame, ignore_index=True)
        return action_csv

    def __concat_data_frame(self, action_csv_all, action_csv):
        """
        拼接DataFrame文件
        :param action_csv_all: 总的DataFrame
        :param action_csv:  新的DataFrame
        :return: action_csv_all
        """
        for index, row in action_csv.iterrows():
            if row["action"] in action_csv_all["action"].values:
                for col in self.csv_col[1:]:
                    # print("当前是:", row["action"], "===>类型", col, "+", row[col])
                    action_csv_all.loc[action_csv_all["action"] == row["action"], col] += row[col]
            else:
                action_csv_all = action_csv_all.append(row, ignore_index=True)
        return action_csv_all

    def __get_action_time(self, path):
        """
        解析mtnx文件，获得其中的动作信息
        :param path: 文件地址
        :return:
        """
        doc = xml.dom.minidom.parse(path)  # dom对象
        root = doc.documentElement
        units = root.getElementsByTagName("unit")
        Pages = root.getElementsByTagName("Page")
        music_path = os.path.join(self.train_music_path, os.path.basename(path).split('.')[0] + ".mp3")
        music_time = self._get_music_time(music_path)
        all_time = 0.0
        action_name, action_start, action_end, action_durative = [], [], [], []
        flag = True
        for unit, page in zip(units, Pages):
            action_time = page.getElementsByTagName('step')[-1].attributes["frame"].value
            loop = unit.attributes["loop"].value  # 循环次数
            for i in range(int(loop)):
                back_time = all_time
                all_time += round(int(action_time) / 128, 2)
                action_name.append(page.attributes["name"].value)
                action_start.append(back_time)
                action_end.append(all_time)
                if all_time >= music_time:
                    action_durative.append([back_time, music_time])
                    flag = False
                action_durative.append([back_time, all_time])
            if not flag:
                break
        return action_name, action_start, action_end, action_durative

    def __generate_action_relation_csv(self):
        """
        从MusicActon中的动作文件中提取出一首歌动作单元(根据动作单元切割音频),生成csv放在MusicActionRelation中
        :return:
        """

        dir_list = os.listdir(self.music_action_path)
        action_duration_time = {}
        for action_path in dir_list:
            # mtnx文件地址
            dance_mtnx = os.path.join(self.music_action_path, action_path)
            # 获取动作文件信息
            action_name, action_start, action_end, action_durative = self.__get_action_time(dance_mtnx)
            # 生成Dataframe保存分割信息
            action = {"action": action_name, "start_time": action_start, "end_time": action_end}
            csv_save_path = os.path.join(self.relation_csv_path, "{}.csv".format(action_path.split(".")[0]))
            pd.DataFrame(action).to_csv(csv_save_path)
            action_duration_time[action_path.split(".")[0]] = action_durative
        print("Successfully save MusicActionRelation !!!")
        return action_duration_time

    def run(self, is_restart=True):
        """
        主函数
        :param is_restart: 是否重新训练模型
        :return:
        """
        action_duration_time = self.__generate_action_relation_csv()  # 处理MusicAction，生成MusicActionRelation信息
        action_csv_all = pd.DataFrame([], columns=self.csv_col)  # 初始化DataFrame
        model_name = self.choose_model(action_duration_time, is_restart)  # 选择重新生成模型还是用最后一次的模型
        for music_name in sorted(os.listdir(self.train_music_path), key=lambda x: x.split('.')[0]):
            music_path = os.path.join(self.train_music_path, music_name)
            # 处理Music信息，生成模型和分类结果放在2020目录下
            result = self.predict_result(model_name, music_path)  # 预测
            # 根据MusicActionRelation的信息关联Music预测结果生成数据集音乐的动作以及其类型分布
            action_csv = self.__generate_signal_action_type(music_name, result)
            # 总结所有的音乐动作以及类型分布放到文件
            action_csv_all = self.__concat_data_frame(action_csv_all, action_csv)
        action_csv_all.to_csv(self.cluster_csv)  # Save action_type.csv
        print(action_csv_all, "\nAction_type.csv OK. Path {}".format(self.cluster_csv))


if __name__ == '__main__':
    MusicAnalysis().run(is_restart=True)  # 音频处理
