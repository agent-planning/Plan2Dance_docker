"""
    音频切割与分析
"""
import sys
import librosa
from pyAudioAnalysis.audioBasicIO import read_audio_file, stereo_to_mono
from pyAudioAnalysis.audioSegmentation import silence_removal
import math
import numpy as np
from plan2dance.Plan2Dance.music_analysis import MusicAnalysis


class GetMusicSegment:
    def __init__(self, ms):
        self.ms = ms
        self.config = self.ms.Config
        self.segment = self.config['segment']
        self.music_path = ms.music_path
        self.music_time = self.__get_music_time(self.music_path)
        ms.music_time = self.music_time
        self.AnalysisClass = MusicAnalysis()
        model_name = self.AnalysisClass.get_lastly_model()
        # 1、解析输入音乐，得到类型分布数组
        self.type_list = self.AnalysisClass.predict_result(model_name, self.music_path)
        self.ms.cluster_data = self.type_list  # type list
        self.ms.model_name = model_name

    def __get_segment_type(self, start_time, end_time):
        """
            获取切割段的类型
        """
        type_list = list(self.type_list)
        type_len = len(type_list)
        weight = int(self.music_time / type_len)
        start = math.floor(start_time / weight)
        end = math.ceil(end_time / weight)
        if start >= type_len - 1:
            start = type_len - 1
        if end >= type_len - 1:
            end = type_len - 1
        cur_list = type_list[start:end]
        if len(cur_list) == 0:
            max_num = type_list[start]
        else:
            max_num = np.argmax(np.bincount(cur_list))
        return [start_time, end_time, max_num]

    def use_silence(self):
        """
            用静默来分段
        """
        print("Use the method of silence...")
        fs, x = read_audio_file(self.music_path)
        x = stereo_to_mono(x)
        st_win = 0.5
        time_segment = silence_removal(x, fs, st_win, st_win, smooth_window=st_win, weight=0.5)
        cur_list = []
        start = 0.0
        for index, section in enumerate(time_segment):
            if len(time_segment) - 1 - index == 0:
                break
            point = (section[1] + time_segment[index + 1][0]) / 2
            arr = self.__get_segment_type(start, point)
            cur_list.append(arr)
            start = point
        arr = self.__get_segment_type(start, self.music_time)
        cur_list.append(arr)
        return cur_list

    @staticmethod
    def __get_music_time(music_path):
        """
        获取当前分析音乐的时长
        :return:
        """
        [fs, x] = read_audio_file(music_path)
        duration = float(len(x)) / fs
        return duration

    def use_cluster(self):
        """
        对整类型分布做一定的切割
        :param type_list:
        :return:
       """
        print("Use the method of cluster...")
        type_list = self.type_list
        index = 0
        point = -1
        end_time = 0.0
        result = []
        weight = (self.music_time / float(len(type_list)))
        if self.segment == "one":
            # 整合为一段
            cur_type = np.argmax(np.bincount(type_list))
            result.append([0, self.music_time, cur_type])
        else:
            while True:
                if len(type_list) - 1 == index:
                    duration_time = float(index - point) * weight
                    start_time = end_time
                    end_time += duration_time
                    arr = [start_time, end_time, type_list[index]]  # 时间，动作序列，类型
                    result.append(arr)
                    break
                if type_list[index + 1] != type_list[index]:
                    duration_time = float(index - point) * weight
                    start_time = end_time
                    end_time += duration_time
                    arr = [start_time, end_time, type_list[index]]  # 时间，动作序列，类型
                    result.append(arr)
                    point = index
                    index += 1
                else:
                    index += 1

        return result

    def beat_tracker(self):
        """
            节拍跟踪
        """
        y, sr = librosa.load(self.music_path)
        tempo, beats = librosa.beat.beat_track(y=y, sr=sr)
        beats_time = librosa.frames_to_time(beats, sr=sr).tolist()
        return beats_time[::3]

    def run(self):
        if self.config['segment_type'] == 'silence':
            segment_result = self.use_silence()
        else:
            segment_result = self.use_cluster()
        beats_time = self.beat_tracker()
        self.ms.beat_list = beats_time
        self.ms.segment_result = segment_result  # type list
        return segment_result