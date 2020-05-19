import os
import time
import multiprocessing
from plan2dance.Plan2Dance.run_planner import RunPlanner
from plan2dance.Plan2Dance.common import PlanResult
from plan2dance.Plan2Dance.planning_domain_definition_language import DomainDefine, SerialProblem, ParallelProblem


class BaseSort:
    def __init__(self, ms):
        self.ms = ms
        self.config = self.ms.Config
        self.time_restrict = self.config['time_restrict']
        self.action_match = None
        self.frequency = ms.frequency_dict

    @staticmethod
    def _init_frequency(frequency_dict):
        return {k.lower(): v for k, v in frequency_dict.items()}

    @staticmethod
    def _get_best_rate(beat_num):
        if beat_num <= 65:
            best_rate = 'slow'
        elif 65 < beat_num < 95:
            best_rate = 'mid'
        else:
            best_rate = 'fast'
        return best_rate

    @staticmethod
    def parallel_processing_with_optic(index, absolute_domain_path, absolute_problem_path, absolute_solution_path,
                                       time_restrict):
        """
            规划求解
        """
        planner = RunPlanner(absolute_domain_path, absolute_problem_path, absolute_solution_path, time_restrict)
        _ = planner.run_optic()  # 规划文件求解

        def __read_file_about_result():
            with open(absolute_domain_path, 'r', encoding='utf-8') as f:
                domain_str = f.read()
            with open(absolute_problem_path, 'r', encoding='utf-8') as f:
                problem_str = f.read()
            with open(absolute_solution_path, 'r', encoding='utf-8') as f:
                plan_data = f.readlines()
            cur_plan = PlanResult(index, domain_str, problem_str, plan_data, 0)
            return cur_plan

        cur_plan = __read_file_about_result()
        return cur_plan

    def _define_domain(self, index, actions):
        """
            定义domain文件
            Param:
                index: int, domain文件下标
                actions: list, 动作列表，根据此列表顺序和值生成domain文件
        """
        domain_name = "d-robot-{}".format(index)
        domain_path = os.path.join(self.ms.domain_dir_path, "d-{}.pddl".format(index))
        frequency_dict = self._init_frequency(self.frequency[index])
        action_match = DomainDefine(self.ms, domain_name, actions, domain_path, frequency_dict).run_generate_domain()
        self.action_match = action_match  # 同步更新domain和problem的action_match文件
        return domain_path

    def _to_solve(self):
        pass

    def run(self):
        """
            主函数
        """
        start = time.time()
        print("Start to plan...")
        # 求解
        self._to_solve()
        end = time.time()
        print("\nPlanning Time: ", end - start, "\n")
        self.ms.planner_use_time = end - start


class ParallelSort(BaseSort):
    """
    定义dummy动作、是否beat_tracker、是否运用action_coherent
    Problem：
        dummy、beat_tracker、action_coherent定义在object、init、preference和metric中
    Domain:
        dummy、beat_tracker、action_coherent定义在predicate、function
    """

    def __init__(self, ms):
        super().__init__(ms)

    def __define_pddl(self):
        action_csv = self.ms.music_select_data

        for index, row in action_csv.iterrows():
            duration = float(row["durative"])
            start = float(row["start"])
            end = float(row["end"])
            actions = row["action"].split(',')
            beat_num = round(row['beat'], 2)
            best_rate = self._get_best_rate(beat_num)
            self._define_domain(index, actions)
            self._define_problem(index, duration, best_rate, start, end)
        return self.ms.problem_dir_path, self.ms.domain_dir_path

    def _define_problem(self, index, duration, best_rate, start, end):
        """
            定义problem文件
                index: int, problem文件下标
                duration: int, problem持续时长
        """
        pd = ParallelProblem(self.ms, self.action_match)
        pd.generate_problem(index, duration, best_rate, start, end)

    def _to_solve(self):
        """
            对于并行计算来说：
                problem_path为保存problem的文件夹
                solution_file_name为保存最后结果的文件夹
        :return:
        """
        problem_dir_path, domain_dir_path = self.__define_pddl()
        solution_path = self.ms.solution_dir_path
        po = multiprocessing.Pool(5)
        plan_list = []
        problem_list = sorted(os.listdir(problem_dir_path), key=lambda x: int(x.split(".")[0].split("-")[1]))
        domain_list = sorted(os.listdir(domain_dir_path), key=lambda x: int(x.split(".")[0].split("-")[1]))
        for index, (domain_path, problem_path) in enumerate(zip(domain_list, problem_list)):
            absolute_domain_path = os.path.join(domain_dir_path, domain_path)
            absolute_problem_path = os.path.join(problem_dir_path, problem_path)
            absolute_solution_path = os.path.join(solution_path, 'plan_{}').format(index)
            result = po.apply_async(self.parallel_processing_with_optic,
                                    (index, absolute_domain_path, absolute_problem_path,
                                     absolute_solution_path, self.time_restrict))  # 规划文件求解
            plan_list.append(result)
        po.close()
        # 等待所有的子进程执行结束， 关闭进程池对象;
        po.join()
        cur_plan_list = []
        for plan in plan_list:
            cur_plan_list.append(plan.get())
        self.ms.plan_list = cur_plan_list


class SerialSort(BaseSort):
    """
    定义dummy动作、是否beat_tracker、是否运用action_coherent
    Problem：
        dummy、beat_tracker、action_coherent定义在object、init、preference和metric中
    Domain:
        dummy、beat_tracker、action_coherent定义在predicate、function
    """

    def __init__(self, ms):
        super().__init__(ms)
        self.action_config = ms.action_config
        self.pre_action = None

    def _define_problem(self, index, duration, best_rate, start, end):
        """
            定义problem文件
                index: int, problem文件下标
                duration: int, problem持续时长
        """
        pd = SerialProblem(self.ms, self.action_match, self.pre_action)
        music_problem_save = pd.generate_problem(index, duration, best_rate, start, end)
        return music_problem_save

    def _define_pddl(self, index, row):
        duration = float(row["durative"])
        start = float(row["start"])
        end = float(row["end"])
        actions = row["action"].split(',')
        beat_num = round(row['beat'], 2)
        best_rate = self._get_best_rate(beat_num)
        domain_path = self._define_domain(index, actions)
        problem_path = self._define_problem(index, duration, best_rate, start, end)
        return domain_path, problem_path

    def _to_solve(self):
        """
            对于并行计算来说：
                problem_path为保存problem的文件夹
                solution_file_name为保存最后结果的文件夹
        :return:
        """
        solution_path = self.ms.solution_dir_path
        action_csv = self.ms.music_select_data
        cur_plan_list = []
        for index, row in action_csv.iterrows():
            domain_path, problem_path = self._define_pddl(index, row)
            absolute_solution_path = os.path.join(solution_path, 'plan_{}').format(index)
            cur_plan = self.parallel_processing_with_optic(index, domain_path, problem_path, absolute_solution_path, self.time_restrict)
            action_name = self._get_before_pose(absolute_solution_path)  # 动作传给problem修改init
            self.pre_action = self._get_upper_name(action_name)
            cur_plan_list.append(cur_plan)

        self.ms.plan_list = cur_plan_list

    def _get_upper_name(self, name):
        """
            获取动作的原名
        """
        flag = False
        upper_name = None
        for key in self.action_config.keys():
            if key.lower() == name.lower():
                flag = True
                upper_name = key
                break
        if flag:
            return upper_name
        else:
            assert "The name don't exist."

    @staticmethod
    def _get_before_pose(solution_path):
        with open(solution_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        last_action = lines[-1]
        last_name_1 = last_action.split(' ')[1].replace('(', '').replace(')', '')
        last_name = last_name_1.split('_')[0]
        return last_name
