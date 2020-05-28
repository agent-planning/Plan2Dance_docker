import sys
import os


class BaseProblem:
    """
        定义问题的基类
    """

    def __init__(self, ms, action_match):
        self.ms = ms
        self.config = self.ms.Config
        self.action_config = ms.action_config
        self.dance_type = self.config["dance_type"]
        self.dummy = self.config["dummy_action"]
        self.rate = self.config["best_rate"]
        self.beat_tracker = self.config["beat_tracker"]
        self.action_coherent = self.config["action_coherent"]
        self.accurate = self.config['accurate']  # 精确值
        self.planner = self.config['planner']
        self.action_frequency = self.config['action_frequency']
        self.beat_list = self.ms.beat_list
        self.action_match = action_match

    @staticmethod
    def _update_beat_list(beat_list, start, end):
        """
            根据start和end标记的时间位置，确定其中存在在其中的beat_list的值
        """
        start_point = None
        end_point = None
        for index, beat in enumerate(beat_list):
            if index == len(beat_list) - 1:
                start_point = index
            if beat >= start:  # start小于当前beat时间，确定当前为其范围内端点
                start_point = index
                break
        for index, beat in enumerate(beat_list):
            if index == len(beat_list) - 1:
                end_point = index + 1
            if beat >= end:  # end小于当前beat时间，确定前一个为其范围内端点
                end_point = index
                break
        new_list = [v - start for v in beat_list[start_point:end_point]]
        return new_list

    def _define_beat(self, which, start=None, end=None):
        """
            定义object和init中的节拍字符串
        """
        if self.beat_tracker == "no":
            return ""
        # update beat
        beat_list = self._update_beat_list(self.beat_list, start, end)
        if which == "init":
            all_beat_str = "(= (beat-satisfy-times) 0)\n"
            for index, beat in enumerate(beat_list):
                start_time = round(beat, 3)
                end_time = round(beat + 0.1, 3)
                start_point = "\t(at {0} (at-beat b{1}))\n".format(start_time, index)
                end_point = "\t(at {0} (not (at-beat b{1})))\n".format(end_time, index)
                cur_beat_str = start_point + end_point
                all_beat_str += cur_beat_str
        elif which == "object":
            all_beat_str = ""
            for index in range(len(beat_list)):
                cur_beat_str = "b{} ".format(index)
                all_beat_str += cur_beat_str
                if ((index + 1) % 5 == 0 and index != 0) or index == len(beat_list) - 1:
                    all_beat_str += "- beat\n"
        else:
            raise KeyError
        return all_beat_str

    def _get_state(self, which):
        state_list = self.action_match.values()
        if which == "init":
            # all_state_str = "(waiting s-init)\n"
            all_state_str = ""
            for state in state_list:
                cur_state_str = "(waiting {})\n".format(state)
                all_state_str += cur_state_str
        else:
            raise KeyError
        return all_state_str

    def _get_execute_times(self, which):
        state_list = self.action_match.values()
        if which == "init":
            all_state_str = ""
            # all_state_str = "(= (execute-times s-init) 0)\n"
            for state in state_list:
                cur_state_str = "(= (execute-times {}) 0)\n".format(state)
                all_state_str += cur_state_str
        else:
            raise KeyError
        return all_state_str

    def _get_dance_time(self, duration):
        min_time = round(duration - float(self.accurate), 3)
        max_time = round(duration + float(self.accurate), 3)
        return min_time, max_time

    def _define_object(self, start, end):
        beat_str = self._define_beat("object", start, end)
        object_str = """(:objects
    {0}
    slow - rate
    mid - rate
    fast - rate
)""".format(beat_str)
        return object_str

    def _define_init_config(self, duration):
        """
            定义目标中用户所选择的偏好
            best_rate: 最佳速率
        """
        add_init_str = "\n\t(= (high-frequency-times) 0)\n\t(= (inter-frequency-times) 0)\n\t"
        if self.dummy == "yes":  # 是否支持哑动作
            add_init_str += """(= (dummy-proportion) {0})
    (= (dummy-total-time) 0)
    (= (dance-total-time) {1})""".format(self.config["dummy_proportion"], duration)
        return add_init_str

    def _define_goal_config(self, best_rate):
        """
            定义目标中用户所选择的偏好
            best_rate: 最佳速率
        """
        add_goal_str = "(forall (?s - state) (preference p-times (< (execute-times ?s) 3)))"
        if self.rate == "yes":  # 是否支持速率
            add_goal_str += """
    (forall (?s - state) (preference p0 (best-rate ?s {})))""".format(best_rate)
        if self.action_frequency == "yes":
            if self.dance_type == "ballet" or self.dance_type == "tibetan":
                add_goal_str += """
    (forall (?s - state) (preference p-frequency (action-frequency ?s dance-frequency)))"""
            else:
                add_goal_str += """
    (forall (?s - state) (preference p-frequency (action-frequency ?s high-frequency)))"""

        if self.dummy == "yes":  # 是否支持哑动作
            add_goal_str += """
    (preference p1 (>= (/ (dummy-total-time) (dance-total-time)) (dummy-proportion)))"""
        if self.beat_tracker == "yes" or self.action_coherent == "yes":  # 是否支持节拍跟踪或者是连贯动作
            if self.beat_tracker == "yes":
                #             add_goal_str += """
                # (forall (?b - beat ?s - state) (preference p2 (beat-satisfy ?b ?s)))"""
                # 改为function记录beat满足数量
                pass
            if self.action_coherent == "yes":
                preference_action_group = self._get_action_group("goal")
                add_goal_str += f"""
    (preference p3 (and
        {preference_action_group}\n\t))"""
            if self.beat_tracker == "yes" and self.action_coherent == "yes":
                add_goal_str += """
    (forall (?s - state) (preference p4 (beat-coherent-satisfy ?s)))"""

        return add_goal_str

    def _define_goal(self, duration, best_rate):
        min_time, max_time = self._get_dance_time(duration)
        add_goal = self._define_goal_config(best_rate)
        goal_str = """(:goal (and
    (> (dance-time) {0})
    (< (dance-time) {1})
    {2}\n)\n)""".format(min_time, max_time, add_goal)
        return goal_str

    def _define_metric(self):
        add_metric = ""
        metric_num = 0
        if self.action_frequency == "yes":
            add_metric += "\t(* 5 (is-violated p-frequency))\n"
            metric_num += 1
        if self.rate == "yes":
            add_metric += "\t(* 2 (is-violated p0))\n"
            metric_num += 1
        if self.dummy == "yes":
            add_metric += "\t(* 2 (is-violated p1))\n"
            metric_num += 1
        if self.beat_tracker == "yes" or self.action_coherent == "yes":
            if self.beat_tracker == "yes":
                add_metric += "\t(* -2 (beat-satisfy-times))\n"
                # add_metric += "\t(* 2 (is-violated p2))\n"
                metric_num += 1
            if self.action_coherent == "yes":
                add_metric += "\t(* 2 (is-violated p3))\n"
                metric_num += 1
            if self.beat_tracker == "yes" and self.action_coherent == "yes":
                add_metric += "\t(* -3 (beat-coherent-satisfy-times))\n"
                metric_num += 1
        if metric_num > 0:
            metric_str = """(:metric minimize (+
    (* 3 (is-violated p-times))
{}\n)\n)""".format(add_metric)
            # if metric_num == 0:
            #     metric_str = """(:metric minimize {})""".format(add_metric)
        else:
            metric_str = """(:metric minimize (* 3 (is-violated p-times)))"""
            # metric_str = ""
        return metric_str

    def _get_action_group(self, which):
        if self.action_coherent == "no":
            return ""
        if which == "init":
            group_str_format = "(= (coherent-satisfy {0} {1}) 0)\n"
        elif which == "goal":
            group_str_format = "(> (coherent-satisfy {0} {1}) 1)\n"
        else:
            raise KeyError
        all_group_str = ""
        for action_name, action_config in self.action_config.items():  # 遍历
            if action_config["coherent"]:  # 当前动作的连贯动作列表不为空
                for before_action_name in action_config["coherent"]:  # 拿出当前动作的连贯动作,放在coherent列表说明当前动作可衔接列表内动作
                    before_action = self.action_match[before_action_name.lower()]
                    after_action = self.action_match[action_name.lower()]
                    # 拿出每个动作的连贯动作
                    group_str = group_str_format.format(before_action, after_action)
                    all_group_str += group_str
        return all_group_str

    def generate_problem(self, index, duration, best_rate, start, end):
        """
            定义problem文件
                index: int, problem文件下标
                duration: int, problem持续时长
        """
        # 循环分段
        problem_name = "robot-{}".format(index)
        object_str = self._define_object(start, end)
        init_str = self._define_init(start, end, duration)
        goal_str = self._define_goal(duration, best_rate)
        metric_str = self._define_metric()
        # Generate
        problem_str = """(define (problem p-{0}) 
(:domain d-{0})
{1}
{2}
{3}
{4}\n)""".format(problem_name, object_str, init_str, goal_str, metric_str)
        save_name = "p-{}.pddl".format(index)
        music_problem_save = os.path.join(self.ms.problem_dir_path, save_name)
        with open(music_problem_save, 'w', encoding='UTF-8') as f:
            f.write(problem_str)
        return music_problem_save

    def _define_init(self, start, end, duration):
        """
            自行定义
        """
        pass


class ParallelProblem(BaseProblem):
    """
        定义并行问题
    """

    def __init__(self, ms, action_match):
        super().__init__(ms, action_match)

    def _define_init(self, start, end, duration):
        beat_str = self._define_beat("init", start, end)
        waiting_str = self._get_state("init")
        execute_times_str = self._get_execute_times("init")
        action_group_str = self._get_action_group("init")
        add_init_str = self._define_init_config(duration)
        init_str = """(:init
    (is_body_free hand-left)
    (is_body_free hand-right)
    (is_body_free leg-left)
    (is_body_free leg-right)

    (at-body-space-y centre)
    (at-body-space-z stand)
    (at-body-space-hand others)

    (= (dance-time) 0)
    (= (action-rate slow) 1.15)
    (= (action-rate mid) 1)
    (= (action-rate fast) 0.85)
   {0}
   {1}
   {2}
   {3}
   {4}
)""".format(add_init_str, beat_str, waiting_str, execute_times_str, action_group_str)
        return init_str


class SerialProblem(BaseProblem):
    """
        定义串行问题
    """

    def __init__(self, ms, action_match, pre_action):
        super().__init__(ms, action_match)
        self.pre_action = pre_action

    def _define_init(self, start, end, duration):
        beat_str = self._define_beat("init", start, end)
        waiting_str = self._get_state("init")
        execute_times_str = self._get_execute_times("init")
        action_group_str = self._get_action_group("init")
        if not self.pre_action:
            body_str = """(is_body_free hand-left)
    (is_body_free hand-right)
    (is_body_free leg-left)
    (is_body_free leg-right)
    (at-body-space-y centre)
    (at-body-space-z stand)
    (at-body-space-hand others)"""
        else:
            body_space_str = self.__get_body_str(self.pre_action)
            body_str = """(is_body_free hand-left)
    (is_body_free hand-right)
    (is_body_free leg-left)
    (is_body_free leg-right)
    {}""".format(body_space_str)
        add_init_str = self._define_init_config(duration)
        init_str = """(:init
    {5}
    (= (dance-time) 0)
    (= (action-rate slow) 1.15)
    (= (action-rate mid) 1)
    (= (action-rate fast) 0.85)
   {0}
   {1}
   {2}
   {3}
   {4}
)""".format(add_init_str, beat_str, waiting_str, execute_times_str, action_group_str, body_str)
        return init_str

    def __get_body_str(self, name):
        """
            获取资源约束字符串
        """
        config = self.action_config[name]
        end_space_y = config['end_space_y']
        end_space_z = config['end_space_z']
        end_hand_position = config['end_hand_position']

        body_str = """(at-body-space-y {0})
        (at-body-space-z {1})
        (at-body-space-hand {2})""".format(end_space_y, end_space_z, end_hand_position)
        return body_str

    @staticmethod
    def __get_before_pose(solution_path):
        with open(solution_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        last_action = lines[-1]
        last_name_1 = last_action.split(' ')[1].replace('(', '').replace(')', '')
        last_name = last_name_1.split('_')[0]
        return last_name
