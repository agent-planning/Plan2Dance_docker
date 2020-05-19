"""
    动作选择
"""
import sys
import copy
from pyAudioAnalysis.audioBasicIO import read_audio_file, stereo_to_mono
import os
import pandas as pd
from random import sample, randint
import re
from pyAudioAnalysis.MidTermFeatures import mid_feature_extraction, beat_extraction
from pydub import AudioSegment
from plan2dance.Plan2Dance.common import AboutClass
from plan2dance.Plan2Dance.common import ProjectPath

"""
-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------动作选择---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
思路
1、先对输入音频进行分段类型预测
2、整合预测结果的类型分布，便于选择动作
3、根据整合结果和action_type.csv文件中动作类型选择动作
"""


class ActionSelect:
    def __init__(self, ms):
        self.ms = ms
        self.action_config = ms.action_config
        self.action_path = ms.action_path
        self.config = self.ms.Config
        self.dance_type = self.config["dance_type"]
        self.segment = self.config['segment']
        self.cluster_csv = os.path.join(ProjectPath, 'Data/Train/action_type.csv')
        self.music_path = ms.music_path
        self.weight = int(self.config['type-weight'])  # 类型分布的间隔
        self.action_select = int(self.config['action-select'])  # action num
        self.action_time = {}
        self.__set_action_type_csv()
        self.temporary_dir_path = self._mkdir_new_dir()
        self.low_action = self.__get_low_action()
        self.ms.low_action = self.low_action

    def _mkdir_new_dir(self):
        """
            Make a new directory to save temporary file
        """
        new_dir_name = self.music_path.split('.')[0]
        if not os.path.exists(new_dir_name):
            os.mkdir(new_dir_name)
        return new_dir_name

    def _get_music_beat_info(self, start, end):
        """
            获取音乐中的bpm等信息
        """

        segment_path = os.path.join(self.temporary_dir_path, "temporary.wav")
        audiofile = AudioSegment.from_file(self.music_path, 'mp3')
        audiofile[start * 1000:end * 1000].export(
            segment_path, format="wav")
        [fs, x] = read_audio_file(segment_path)
        x = stereo_to_mono(x)  # 将双声道或立体声的信号转为单声道，声道可以说是录制时候的音源数量问题
        mt_win = 1
        mt_step = 2
        st_win = 0.1
        st_step = 0.1
        try:
            [_, st_features, _] = mid_feature_extraction(x, fs, round(mt_win * fs),
                                                      round(mt_step * fs),
                                                      round(fs * st_win),
                                                      round(fs * st_step))
            [beat, beat_conf] = beat_extraction(st_features, st_step)
        except:
            print("beat特征提取错误")
            beat, beat_conf = 0, 0
        os.remove(segment_path)
        return beat, beat_conf

    def __get_low_action(self):
        """
            获取时间较少的动作
        """
        actions = os.listdir(self.action_path)
        low_action = []
        for action in actions:
            cur_action = action.split('.')[0]
            path = os.path.join(self.action_path, '{}.mtnx'.format(cur_action))
            with open(path, 'r', encoding='utf-8') as f:
                action_content = f.read()
            frame = re.findall(r'frame="\d+"', action_content)[-1]
            frame = re.findall(r'\d+', frame)[0]
            time = round(float(frame) / 128, 3)
            self.action_time[cur_action] = time
            if time < 1:
                low_action.append(cur_action)
        return low_action

    def __get_action_time(self, action_name):
        """
        获取动作的时长
        :param action_name: 动作名称
        :return:
        """
        actions = os.listdir(self.action_path)
        for action in actions:
            cur_action = action.split('.')[0]
            if action_name.lower() == cur_action.lower():
                action_name = cur_action
                break
        if action_name in self.action_time.keys():
            return self.action_time[action_name]
        else:
            path = os.path.join(self.action_path, '{}.mtnx'.format(action_name))
            with open(path, 'r') as f:
                action_content = f.read()
            frame = re.findall(r'frame="\d+"', action_content)[-1]
            frame = re.findall(r'\d+', frame)[0]
            time = round(float(frame) / 128, 3)
            self.action_time[action_name] = time
            if time < 1:
                self.low_action.append(action_name)
            return time

    def __get_type(self):
        """
            获取类型
        """
        if 'cluster-count' in self.config:
            cluster_count = int(self.config['cluster-count'])
            type_list = []
            for i in range(cluster_count):
                type_list.append('type_' + str(i))
            return type_list

    def __select_from_csv_by_type(self, type_select, ductive_time, action_select):
        """
        根据类型来选择动作
        :param type_select: 类型
        :return: 动作列表
        """
        if self.dance_type == "pop":
            self.ms.action_type_csv['type-probability'] = self.ms.action_type_csv['probability'] * \
                                                          self.ms.action_type_csv[
                                                              "type_" + str(type_select)]
            sort_csv = self.ms.action_type_csv.sort_values(by="type-probability", ascending=False).drop(
                columns=['type-probability'])
            value = 7
            actions = [action for action in sort_csv[0:value]["action"]]
            if ductive_time < 4.5:
                num = 5
                if ductive_time < 2.5:
                    low_action = self.ms.low_action
                    cur_sort_low_action = []
                    actions = [action for action in sort_csv["action"]]  # All include the duration in [0.5,0.8]
                    for action in actions:
                        if action in low_action:
                            cur_sort_low_action.append(action)
                    actions = cur_sort_low_action
                    if len(actions) >= 3:
                        num = 3
                    else:
                        num = len(actions)
            else:
                num = randint(action_select, action_select + 1)
            if self.segment == "one":
                actions = [action for action in sort_csv["action"]]
                cur_actions = copy.copy(actions)
            else:
                cur_actions = sample(actions, num)
            # 1、定义选择的动作为高频动作
            cur_actions = [v.lower() for v in cur_actions]  # 变为小写
            high_list = copy.copy(cur_actions)
            dance_show_actions = [action.lower() for action in sort_csv["action"]]
            # 2、定义出现在已有舞蹈但不属于1的动作为中频动作
            intermediate_list = list(set(dance_show_actions).difference(set(cur_actions)))  # 求差集
            cur_actions.extend(intermediate_list)
            # 3、定义不出现在已有舞蹈的动作为低频动作
            low_list = list(set([v.lower() for v in self.action_config.keys()]).difference(set(cur_actions)))  # 求差集
            cur_actions.extend(low_list)
            action_str = str()
            for action in cur_actions:
                action_str += ("," + str(action))
            action_frequency = self.__get_action_frequency(high_list, intermediate_list, low_list)  # 定义频率字典
        else:
            # 民族舞没有已有数据
            # 那么所有动作都是初始数据
            high_list, intermediate_list = [], []
            low_list = [v.lower() for v in self.action_config.keys()]
            action_frequency = self.__get_action_frequency(high_list, intermediate_list, low_list)
            action_str = str()
            for action in low_list:
                action_str += ("," + str(action))
        return action_frequency, action_str[1:]  # sample随机选择列表中动作，randint随机动作个数

    @staticmethod
    def __get_action_frequency(high_list, intermediate_list, low_list):
        """
            整理动作频率
        """
        cur_dict = {}
        for action in high_list:
            cur_dict[action] = 'high-frequency'
        for action in intermediate_list:
            cur_dict[action] = "intermediate-frequency"
        for action in low_list:
            cur_dict[action] = "low-frequency"
        return cur_dict

    def __set_action_type_csv(self):
        """
        读取action_type_csv文件并处理其中的参数
        :return:
        """
        action_type_csv = pd.read_csv(self.cluster_csv)
        # 对type字段进行归一化
        for action_type_select in self.__get_type():
            action_type_csv[action_type_select] = round(
                100 * (action_type_csv[action_type_select] / sum(action_type_csv[action_type_select])), 3)
        self.ms.action_type_csv = action_type_csv 

    def __select_action(self, segment_result):
        """
            对整合后的类型分布做一定的切割，然后选择动作
        :return:
        """
        col = ['start', 'end', 'durative', 'action', 'type', 'beat', 'beat_conf']
        action_csv = pd.DataFrame([], columns=col)
        frequency_dict = dict()
        point = 0
        for row in segment_result:

            start_time = row[0]
            end_time = row[1]
            action_type = row[2]
            duration_time = end_time - start_time
            # 分段获取每段的节拍信息
            beat, beat_conf = self._get_music_beat_info(start_time, end_time)

            if duration_time > 18 and self.config['segment'] != 'one':
                cur_duration_time = duration_time / 2
                action_frequency, actions = self.__select_from_csv_by_type(action_type, cur_duration_time,
                                                                           self.action_select)
                arr = [start_time, end_time - cur_duration_time, cur_duration_time, actions, action_type, beat,
                       beat_conf]  # 时间，动作序列，类型
                current_csv = pd.DataFrame([arr], columns=col)
                action_csv = action_csv.append(current_csv, ignore_index=True)
                # 两个值
                frequency_dict[point] = action_frequency
                point += 1
                action_frequency, actions = self.__select_from_csv_by_type(action_type, cur_duration_time,
                                                                           self.action_select)
                arr = [start_time + cur_duration_time, end_time, cur_duration_time, actions, action_type, beat,
                       beat_conf]  # 时间，动作序列，类型
                current_csv = pd.DataFrame([arr], columns=col)
                action_csv = action_csv.append(current_csv, ignore_index=True)
                frequency_dict[point] = action_frequency
            else:
                action_frequency, actions = self.__select_from_csv_by_type(action_type, duration_time,
                                                                           self.action_select)
                arr = [start_time, end_time, duration_time, actions, action_type, beat, beat_conf]  # 时间，动作序列，类型
                current_csv = pd.DataFrame([arr], columns=col)
                action_csv = action_csv.append(current_csv, ignore_index=True)
                # 返回动作列表
                frequency_dict[point] = action_frequency
            point += 1
        return frequency_dict, action_csv

    def __select_action_folk_dance(self, segment_result):
        """
        对整合后的类型分布做一定的切割，然后选择动作
        :return:
        """
        col = ['start', 'end', 'durative', 'action', 'type', 'beat', 'beat_conf']
        action_csv = pd.DataFrame([], columns=col)
        frequency_dict = dict()
        point = 0
        for row in segment_result:

            start_time = row[0]
            end_time = row[1]
            action_type = row[2]
            duration_time = end_time - start_time
            # 分段获取每段的节拍信息
            beat, beat_conf = self._get_music_beat_info(start_time, end_time)

            if duration_time > 18 and self.config['segment'] != 'one':
                cur_duration_time = duration_time / 2
                action_frequency, actions = self.__select_from_csv_by_type(action_type, cur_duration_time,
                                                                           self.action_select)
                arr = [start_time, end_time - cur_duration_time, cur_duration_time, actions, action_type, beat,
                       beat_conf]  # 时间，动作序列，类型
                current_csv = pd.DataFrame([arr], columns=col)
                action_csv = action_csv.append(current_csv, ignore_index=True)
                # 两个值
                frequency_dict[point] = action_frequency
                point += 1
                action_frequency, actions = self.__select_from_csv_by_type(action_type, cur_duration_time,
                                                                           self.action_select)
                arr = [start_time + cur_duration_time, end_time, cur_duration_time, actions, action_type, beat,
                       beat_conf]  # 时间，动作序列，类型
                current_csv = pd.DataFrame([arr], columns=col)
                action_csv = action_csv.append(current_csv, ignore_index=True)
                frequency_dict[point] = action_frequency
            else:
                action_frequency, actions = self.__select_from_csv_by_type(action_type, duration_time,
                                                                           self.action_select)
                arr = [start_time, end_time, duration_time, actions, action_type, beat, beat_conf]  # 时间，动作序列，类型
                current_csv = pd.DataFrame([arr], columns=col)
                action_csv = action_csv.append(current_csv, ignore_index=True)
                # 返回动作列表
                frequency_dict[point] = action_frequency
            point += 1
        return frequency_dict, action_csv

    def run(self):
        # 根据类型在action_type.csv文件中选择动作,将选择的动作输出到select_action.csv中
        segment_result = self.ms.segment_result
        frequency_dict, action_select = self.__select_action(segment_result)
        self.ms.music_select_data = action_select  # The information of action select
        self.ms.frequency_dict = frequency_dict
        # print(frequency_dict)
        self.ms.action_time = self.action_time


def action_select_by_read(pkl_path):
    ms = AboutClass.read(pkl_path)
    class_as = ActionSelect(ms)
    class_as.run()
    AboutClass.save(pkl_path, class_as.ms)


if __name__ == '__main__':
    pkl_path = sys.argv[1]
    action_select_by_read(pkl_path)
