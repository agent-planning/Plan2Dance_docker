import os
import pandas as pd
import shutil
import time
from plan2dance.Plan2Dance.common import ProjectPath


class Music(object):
    """
Music object,save some information like "cluster_data","final_plan" and soon.
Attributes:
    {
        'music_path': Str, The path of music.
        'music_name': Str, Music Name.
        'music_type': Str, Music Type.
        'cluster_data': List, The result by cluster model.
        'segment_result': List, Which method in the music music segment.
        'plan_list': List, Composed of "PlanResult" which is a class.
        'action_type_csv': DataFrame, From the MusicAnalysis.It use to constitute the "music_select_data".
        'music_select_data': DataFrame, The action select information about this Music.
        'final_plan': list, The final plan.
        'domain_file': Str, The part of PDDL file.
        'model_name': Str, Adopt model name.
        'music_time': Str, The music time.
        'operation_frequency': Dict, All the actions frequency.
        'cur_time': Str, Start time.
        'MTNX_file':Str, About the robot dance show.
        'Config':Dict, Plan2Dance.cfg.

        Others are the path of the file, so don`t show here.
    }
PS:
    class PlanResult:
    self.seq = seq  # Int, number
    self.problem = problem  #Str, problem file
    self.plan = plan  # List, plan constitute of each line
    self.success = True
    self.repeat = repeat # planner repeat number in this duration.(Because of the Action selection is not reasonable.)

So if you want to look up the Plan, you can foreach the "Music(input_music).plan_list".

    """

    def __init__(self, music_path, config):
        self.music_path = os.path.abspath(music_path)
        self.music_name = os.path.basename(music_path).split('.')[0]
        self.music_type = os.path.basename(os.path.dirname(music_path))
        self.__set_music_output_path()  # Set the music output path
        self.cluster_data = []  # Cluster result
        self.music_select_data = pd.DataFrame()  # Action select csv
        self.action_type_csv = pd.read_csv(
            os.path.join(ProjectPath, "Data/Train/action_type.csv"))  # Action select csv
        self.plan_list = []  # Insert the object PlanResult
        self.final_plan = []  # The final plan,insert the row of plan
        self.segment_result = []
        self.operation_frequency = {}
        self.model_name = str()  # 所使用模型名称
        self.music_time = None  # 音乐时长
        self.cur_time = self.__generate_date()  # 当前时间
        self.domain_file = str()  # domain文件
        self.MTNX_file = str()  # mtnx的output文件
        self.Config = config  # 参数列表
        self.planner_use_time = 0  # 程序调用加上等待时长的时间
        self.action_time = {}
        self.frequency_dict = None
        self.low_action = []  #
        self.beat_list = None  # 节拍列表
        self.real_plan_time_cost = None  # 规划求解的实际时长
        self.action_path = None  # 本次调用所使用的动作库地址
        self.action_config = None  # 本次调用所使用的动作config

    @staticmethod
    def __generate_date():
        loc_time = time.localtime()
        if len(str(loc_time.tm_mon)) == 1:
            month = loc_time.tm_mon
        else:
            month = loc_time.tm_mon
        return "{}/{},{}  {}:{}".format(month, loc_time.tm_mday, loc_time.tm_year, loc_time.tm_hour,
                                        loc_time.tm_min)

    def __str__(self):
        return "This is a result class of the music \"{}\".\nStarted in {}".format(self.music_name, self.cur_time)

    def __set_music_output_path(self):
        music_type_dir = os.path.abspath(os.path.join(ProjectPath, "Data/Result/output/music", self.music_type))
        if not os.path.exists(music_type_dir):
            os.mkdir(music_type_dir)
        # music output dir
        self.music_dir_output_path = os.path.join(music_type_dir, self.music_name)
        # set the pddl path
        self.pddl_dir_path = os.path.join(self.music_dir_output_path, "pddl")
        self.problem_dir_path = os.path.join(self.pddl_dir_path, "problem")
        self.domain_dir_path = os.path.join(self.pddl_dir_path, "domain")
        self.domain_path = os.path.join(self.pddl_dir_path, "domain.pddl")
        # set the each solution path
        self.solution_dir_path = os.path.join(self.music_dir_output_path, "solution")
        # set the final plan path
        self.plan_dir_path = os.path.join(self.music_dir_output_path, "plan")
        self.mtnx_path = os.path.join(self.plan_dir_path, "{}.mtnx".format(self.music_name))
        self.final_plan_path = os.path.join(self.plan_dir_path, "solution.plan")
        self.action_select_path = os.path.join(self.music_dir_output_path, "action_select.csv")

        # make dirs
        if os.path.exists(self.music_dir_output_path):
            shutil.rmtree(self.music_dir_output_path)
        time.sleep(1)
        os.mkdir(self.music_dir_output_path)
        os.mkdir(self.pddl_dir_path)
        os.mkdir(self.problem_dir_path)
        os.mkdir(self.domain_dir_path)
        os.mkdir(self.solution_dir_path)
        os.mkdir(self.plan_dir_path)
        time.sleep(1)

    def set_config(self, config):
        self.Config = config
