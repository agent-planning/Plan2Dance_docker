"""
    生成domain文件
"""
import os
import re
from plan2dance.Plan2Dance.common.chars import (
    SpecialDomainHeadStr,
    SpecialFuncAndPreStr,
    SpecialActionStr,
    ActionTransition,
    DummyAction
)
from plan2dance.Plan2Dance.config import IOConfig
from plan2dance.Plan2Dance.prepare import PopActionsDefine
from plan2dance.Plan2Dance.common import ProjectPath


class DomainDefine:
    """
        生成domain文件
    """

    def __init__(self, ms, name, actions, domain_path, frequency):
        self.config = ms.Config
        self.action_path = ms.action_path
        self.action_config = ms.action_config
        self.dummy = self.config["dummy_action"]
        self.best_rate = self.config["best_rate"]
        self.beat_tracker = self.config["beat_tracker"]
        self.action_coherent = self.config["action_coherent"]
        self.accurate = self.config['accurate']  # 精确值
        self.planner = self.config['planner']
        self.action_frequency = self.config['action_frequency']
        self.name = name
        self.actions_dict = self._get_actions()
        self.actions = self.__init__actions(actions)  # 保证actions为config定义的所有动作
        self.frequency = frequency
        self.action_match = self.__init__define_constant_name(self.actions)
        self.domain_path = domain_path
        self.actions_num = len(self.actions)
        self.domain_head_str = SpecialDomainHeadStr
        self.func_and_pre_str = SpecialFuncAndPreStr

    @staticmethod
    def __init__actions(actions):
        """
            初始化动作列表
        """
        cur_actions = [v.lower() for v in actions]
        return cur_actions

    def _get_actions(self):
        actions = [v.split('.')[0] for v in os.listdir(self.action_path)]
        data = {}
        for action in actions:
            data[str(action.lower())] = str(action)
        return data

    @staticmethod
    def __init__define_constant_name(actions):
        """
            定义动作和state的对应关系
        """
        cur_dict = {}
        for index, action in enumerate(actions):
            cur_state = 's{}'.format(index + 1)
            cur_dict[action] = cur_state
        return cur_dict

    def __get_constant(self):
        """
            Domain部分：获取常量字符串（constant）
        """
        state_str = str()
        for i in range(self.actions_num):
            cur_state = 's{}'.format(i + 1)
            state_str += (cur_state + '\t')
            if (i + 1) % 5 == 0 or (i + 1) == self.actions_num:
                state_str += ' - state\n'
        constant_str = """(:constants
    {0}
    forward centre backward - space-y
    stand half-squat squat - space-z
    chest others - space-hand
    hand-left hand-right leg-left leg-right - body-parts
    high-frequency intermediate-frequency low-frequency dance-frequency common-frequency - frequency
)""".format(state_str)
        return constant_str

    def __get_func_pre(self):
        """
            Domain部分：获取函数和谓词字符串（function、predicate）
        """
        add_pre_str = ""
        add_func_str = ""
        if self.action_frequency == "yes":
            add_pre_str += """(action-frequency ?s - state ?f - frequency)
    """
        if self.best_rate == "yes":
            add_pre_str += """(best-rate ?s - state ?rate - rate) ;最佳速率
    """

        if self.dummy == "yes":
            add_func_str += """(dance-total-time)
    (dummy-total-time)
    (dummy-proportion)
    """
        if self.beat_tracker == "yes" or self.action_coherent == "yes":
            if self.beat_tracker == "yes":
                add_pre_str += """
    (at-beat ?b - beat) ; 定义节拍出现点
    (beat-satisfy ?b - beat ?s - state) ; 满足节拍条件
    """
                add_func_str += """
    (beat-satisfy-times)
    """
            if self.action_coherent == "yes":
                add_func_str += """(coherent-satisfy ?s - state ?st - state)
                """
            if self.beat_tracker == "yes" and self.action_coherent == "yes":
                add_pre_str += """(beat-coherent-satisfy ?s - state) ; 满足连贯和节拍满足
                """
                add_func_str += """(beat-coherent-satisfy-times)"""
        return self.func_and_pre_str.format(add_pre_str, add_func_str)

    def __get_action(self):
        """
            Domain部分：获取动作字符串（Action、durative-action）
        """
        action_all_str = ActionTransition + "\n"

        # action_all_str = ""
        if self.dummy == "yes":
            action_all_str += DummyAction.format(1.0)  # 定义哑动作时长
        # 此处的循环更改为通过动作列表循环
        action_config = {k.lower(): v for k, v in self.action_config.items()}
        for action, state in self.action_match.items():
            real_name = self.actions_dict[action]
            cur_action_str = Action(action_config, self.action_path, self.config, real_name, state, self.action_match,
                                    self.frequency).get_str()
            action_all_str += (cur_action_str + '\n')
        return action_all_str

    def run_generate_domain(self):
        """
            运行生成domain文件
        """
        # 1、初始化domain头部字符串
        head_str = self.domain_head_str.format(self.name)
        # 2、获取domain常量部分
        constant_str = self.__get_constant()
        # 3、获取domain的谓词和函数部分
        func_pre = self.__get_func_pre()
        # 4、获取domain的动作部分
        action_str = self.__get_action()
        # 5、拼接生成domain
        domain_str = head_str + constant_str + func_pre + action_str + '\n)\n'
        # 6、保存domain
        with open(self.domain_path, 'w', encoding='utf-8') as f:
            f.write(domain_str)
        return self.action_match


class Action:
    """
        生成动作（action）
    """

    def __init__(self, action_config, action_path, config, name: str, state: str, action_match, frequency: dict):
        self.action_config = action_config
        self.action_path = action_path
        self.name = name.lower()
        self.real_name = name
        self.state = state
        self.action_match = action_match
        self.frequency = frequency
        self.dance_type = config["dance_type"]
        self.dummy = config["dummy_action"]
        self.best_rate = config["best_rate"]
        self.beat_tracker = config["beat_tracker"]
        self.action_coherent = config["action_coherent"]
        self.action_frequency = config['action_frequency']
        self.time = self.__get_time()
        self.action_str = SpecialActionStr
        self.action_frequency_value = self.__get_action_frequency(self.name)
        self.all_action = None
        self._define_action()

    def _get_is_action_dance_type(self):
        """
            民族舞专用：判断动作是否属于民族特色动作
        """
        is_current_dance_type = self.action_config[self.name]['is_current_dance_type']
        return is_current_dance_type

    def __get_param(self, which):
        """
            获取当前动作配置中的资源约束
        """
        data = {}
        if which == "body":
            data['hand_right_use'] = self.action_config[self.name]['hand_right_use']
            data['hand_left_use'] = self.action_config[self.name]['hand_left_use']
            data['leg_right_use'] = self.action_config[self.name]['leg_right_use']
            data['leg_left_use'] = self.action_config[self.name]['leg_left_use']

        elif which == "rate":
            data['time_change_allowed'] = self.action_config[self.name]['time_change_allowed']
        elif which == "position":
            data['start_space_y'] = self.action_config[self.name]['start_space_y']
            data['start_space_z'] = self.action_config[self.name]['start_space_z']
            data['start_hand_position'] = self.action_config[self.name]['start_hand_position']
            data['end_space_y'] = self.action_config[self.name]['end_space_y']
            data['end_space_z'] = self.action_config[self.name]['end_space_z']
            data['end_hand_position'] = self.action_config[self.name]['end_hand_position']
        else:
            raise KeyError
        return data

    def __get_time(self):
        """
            获取动作的时长
            :return:
            """
        path = os.path.join(self.action_path, '{}.mtnx'.format(self.real_name))
        with open(path, 'r', encoding="UTF-8") as f:
            action_content = f.read()
        frame = re.findall(r'frame="\d+"', action_content)[-1]
        frame = re.findall(r'\d+', frame)[0]
        time = round(float(frame) / 128, 3)
        return time

    def __get_duration(self):
        """
            action部分：duration模块时间的定义
        """
        # 获取当前动作的速率信息
        time_change_allowed = self.__get_rate()
        if time_change_allowed:
            duration = "(* {} (action-rate ?rate))".format(self.time)
        else:
            duration = "{}".format(self.time)
        return duration

    def __get_rate(self):
        """
            返回当前动作的速率允许信息
        """
        time_change_allowed = self.action_config[self.name]["time_change_allowed"]
        return time_change_allowed

    def __get_coherent(self):
        """
            获取当前动作的连贯信息
        """
        coherent = self.action_config[self.name]['coherent']
        return coherent

    def __confirm_config(self):
        """
            确定特征动作
        """
        candicate_action = []
        if self.beat_tracker == "yes" or self.action_coherent == "yes":
            if self.beat_tracker == "yes" and self.action_coherent == "yes":
                candicate_action.append('beat_coherent')
            if self.action_coherent == "yes":
                candicate_action.append('coherent')
            if self.beat_tracker == "yes":
                candicate_action.append('beat')
        candicate_action.append('normal')
        return candicate_action

    def __get_action(self, action, action_name, coherent_name=None):
        """
            获取动作
        """
        # 1、获取duration中的参数
        param = self._define_param(action)
        # 2、获取动作持续时间
        duration = self.__get_duration()  # 定义持续时间
        # 3、获取开始前提
        condition_start = self._define_condition_start(action, coherent_name)  # 定义前提
        # 4、获取开始效果
        effect_start = self._define_effect_start(action, coherent_name)  # 定义效果的start
        # 5、获取结束效果
        effect_end = self._define_effect_end(action, coherent_name)  # 定义效果的end
        # 6、定义完整的动作字符串
        cur_action = self.action_str.format(action_name, param, duration, condition_start, effect_start,
                                            effect_end)
        return cur_action

    def _define_action(self):
        """
            定义动作
        """
        # 确定特征动作
        candicate_action = self.__confirm_config()
        # 这里将修改coherent动作为固定动作

        all_action_str = ""
        for action in candicate_action:
            if action == "normal":
                action_name = self.name
                cur_action = self.__get_action(action, action_name)
            elif action == "coherent" or action == "beat_coherent":
                coherent = self.__get_coherent()
                cur_action = ""
                # 遍历当前动作后面所衔接的动作列表
                for coherent_action in coherent:
                    action_name = "{0}_{1}_{2}".format(self.name, coherent_action, action)
                    cur_coherent_action = self.__get_action(action, action_name, coherent_action)
                    cur_action += cur_coherent_action
            else:
                action_name = self.name + "_{0}".format(action)
                cur_action = self.__get_action(action, action_name)
            all_action_str += cur_action
        self.all_action = all_action_str

    def _define_param(self, witch):
        """
            定义duration的参数
        """
        data = self.__get_param("rate")
        rate = data['time_change_allowed']
        if rate:
            add_param = "?rate - rate"
        else:
            add_param = ""
        if witch == "normal" or witch == "coherent":
            pass
        # elif witch == "coherent":
        #     add_param += " ?s - state"
        elif witch == "beat" or witch == "beat_coherent":
            add_param += " ?beat - beat"
        # elif witch == "beat_coherent":
        #     add_param += " ?beat - beat ?s - state"
        else:
            raise KeyError
        return add_param

    def __get_action_constraints(self, which):
        """
            获取动作的资源约束
        """
        data = self.__get_param("body")
        hand_right_use = data['hand_right_use']
        hand_left_use = data['hand_left_use']
        leg_right_use = data['leg_right_use']
        leg_left_use = data['leg_left_use']

        if hand_right_use:
            hand_right = "(is_body_free hand-right)"
        else:
            hand_right = ""
        if hand_left_use:
            hand_left = "(is_body_free hand-left)"
        else:
            hand_left = ""
        if leg_right_use:
            lef_right = "(is_body_free leg-right)"
        else:
            lef_right = ""
        if leg_left_use:
            leg_left = "(is_body_free leg-left)"
        else:
            leg_left = ""
        if not which:
            if hand_right:
                hand_right = "(not {})".format(hand_right)
            if hand_left:
                hand_left = "(not {})".format(hand_left)
            if lef_right:
                lef_right = "(not {})".format(lef_right)
            if leg_left:
                leg_left = "(not {})".format(leg_left)

        default = """{0}
            {1}
            {2}
            {3}
            """.format(hand_right, hand_left, lef_right, leg_left)
        return default

    def __get_position_constraints(self, which):
        """
            获取动作位置约束
        """
        data = self.__get_param('position')
        if which == "condition":
            # result = "(at-body-space {0} {1} {2})"
            result = """(at-body-space-y {0})
            (at-body-space-z {1})
            (at-body-space-hand {2})""".format(data['start_space_y'], data['start_space_z'],
                                               data['start_hand_position'])
        elif which == "effect_start":
            # result = "(not (at-body-space {0} {1} {2}))".format(data['start_space_y'],
            #                                                     data['start_space_z'],
            #                                                     data['start_hand_position'])
            result = """(not (at-body-space-y {0}))
            (not (at-body-space-z {1}))
            (not (at-body-space-hand {2}))""".format(data['start_space_y'], data['start_space_z'],
                                                     data['start_hand_position'])
        elif which == "effect_end":
            # result = "(at-body-space {0} {1} {2})".format(data['end_space_y'], data['end_space_z'],
            #                                               data['end_hand_position'])
            result = """(at-body-space-y {0})
            (at-body-space-z {1})
            (at-body-space-hand {2})""".format(data['end_space_y'], data['end_space_z'],
                                               data['end_hand_position'])
        else:
            raise KeyError
        return result

    def _define_condition_start(self, witch, coherent_name=None):
        """
            定义动作的开始前提
        """
        body_constraints = self.__get_action_constraints(True)
        space_constraints = self.__get_position_constraints('condition')
        constraints_str = body_constraints + space_constraints
        if witch == "normal":
            add_condition = """(waiting {0})
            {1}""".format(self.state, constraints_str)
        elif witch == "coherent":
            if not coherent_name:
                raise
            coherent_state = self.action_match[coherent_name.lower()]
            add_condition = """(waiting {0})
            (finished {2})
            {1}""".format(self.state, constraints_str, coherent_state)
        elif witch == "beat":
            add_condition = """(waiting {0})
            (at-beat ?beat)
            {1}""".format(self.state, constraints_str)
        elif witch == "beat_coherent":
            if not coherent_name:
                raise
            coherent_state = self.action_match[coherent_name.lower()]
            add_condition = """(waiting {0})
            (finished {2})
            (at-beat ?beat)
            {1}""".format(self.state, constraints_str, coherent_state)
        else:
            raise KeyError
        return add_condition

    def _define_effect_start(self, witch, coherent_name=None):
        """
            定义动作的开始效果
        """
        body_constraints = self.__get_action_constraints(False)
        space_constraints = self.__get_position_constraints('effect_start')
        constraints_str = body_constraints + space_constraints
        if witch == "normal":
            add_effect = constraints_str
        elif witch == "coherent":
            if not coherent_name:
                raise KeyError
            coherent_state = self.action_match[coherent_name.lower()]
            add_effect = """{0}
            (increase (coherent-satisfy {2} {1}) 1)""".format(constraints_str, self.state, coherent_state)
        elif witch == "beat":
            add_effect = """{0}
            """.format(constraints_str, self.state)
        elif witch == "beat_coherent":
            if not coherent_name:
                raise KeyError
            coherent_state = self.action_match[coherent_name.lower()]
            add_effect = """{0}
            (increase (coherent-satisfy {2} {1}) 1) ; 定义动作连贯
             ; 定义动作连贯和节拍对应
            """.format(constraints_str, self.state, coherent_state)
        else:
            raise KeyError
        return add_effect

    def __get_action_frequency(self, name):
        try:
            value = self.frequency[name.lower()]
            return value
        except KeyError:
            raise

    def _define_effect_end(self, witch, coherent_name=None):
        """
            定义动作的结束效果
        """
        rate = self.action_config[self.name]["time_change_allowed"]
        if self.best_rate == "yes" and rate:
            add_effect_before = """(increase (execute-times {1}) 1)
            (best-rate {1} ?rate)
            (finished {1})
            """
        else:
            add_effect_before = """(increase (execute-times {1}) 1)
            (finished {1})
            """
        # 定义高低频率动作
        if self.action_frequency == "yes":
            # 民族舞处理动作频率,这里使用dance和common两种区分动作
            # 因为民族舞没有已有编舞，所以通过区分民族舞元素动作和非民族舞元素动作来定义偏好1
            if self.dance_type == "ballet" or self.dance_type == "tibetan":
                if self._get_is_action_dance_type():
                    action_type = "dance-frequency"
                else:
                    action_type = "common-frequency"
                frequency_str = f"(action-frequency {self.state} {action_type})\n\t\t\t"
                add_effect_before += frequency_str
            else:
                # 流行舞存在已有编舞，通过定义已有编舞中存在的动作出现频率来区分动作
                frequency_str = f"(action-frequency {self.state} {self.action_frequency_value})\n\t\t\t"
                add_effect_before += frequency_str
                if self.action_frequency_value == "high-frequency":
                    add_effect_before += "(increase (high-frequency-times) 1)\n"
                elif self.action_frequency_value == "intermediate-frequency":
                    add_effect_before += "(increase (inter-frequency-times) 1)\n"
        body_constraints = self.__get_action_constraints(True)  # 获取身体约束
        space_constraints = self.__get_position_constraints('effect_end')  # 获取空间约束
        constraints_str = body_constraints + space_constraints
        # 特征动作区分，设置效果中的前提和影响
        if witch == "normal":
            add_effect_format = add_effect_before + """{0}
            """
            add_effect = add_effect_format.format(constraints_str, self.state)
        elif witch == "coherent":
            if not coherent_name:
                raise KeyError
            coherent_state = self.action_match[coherent_name.lower()]
            add_effect_format = add_effect_before + """{0}
            (not (finished {2}))
            """
            add_effect = add_effect_format.format(constraints_str, self.state, coherent_state)
        elif witch == "beat":
            add_effect_format = add_effect_before + """{0}
            (increase (beat-satisfy-times) 1)
            """
            add_effect = add_effect_format.format(constraints_str, self.state)
        elif witch == "beat_coherent":
            if not coherent_name:
                raise KeyError
            coherent_state = self.action_match[coherent_name.lower()]
            add_effect_format = add_effect_before + """{0}
            (not (finished {2}))
            (increase (beat-satisfy-times) 1)
            (increase (beat-coherent-satisfy-times) 2)
            """
            add_effect = add_effect_format.format(constraints_str, self.state, coherent_state)
        else:
            raise KeyError
        return add_effect

    def get_str(self):
        """
            获取动作字符串
        """
        return self.all_action


class ActionResult:
    """
        作为step1的输出
    """

    def __init__(self, pop_action_path):
        self.action_path = pop_action_path
        self.action_config = PopActionsDefine
        self.config = self._init_config()
        self.action_list = [v.lower() for v in PopActionsDefine.keys()]
        self.frequency = self.__get_action_frequency([], [], self.action_list)
        self.action_match = self.__init_define_constant_name(list(PopActionsDefine.keys()))

    @staticmethod
    def _init_config():
        config = IOConfig().get_config()
        return config

    @staticmethod
    def __init_define_constant_name(actions):
        """
            定义动作和state的对应关系
        """
        cur_dict = {}
        for index, action in enumerate(actions):
            cur_state = 's{}'.format(index + 1)
            cur_dict[action] = cur_state
        return cur_dict

    def get_common_action(self):
        """
            获取到所有common action的字符串返回
        """
        action_all_str = str()
        action_config = {k.lower(): v for k, v in self.action_config.items()}
        for action, state in self.action_match.items():
            cur_action_str = Action(action_config, self.action_path, self.config, action, state, self.action_match,
                                    self.frequency).get_str()
            action_all_str += (cur_action_str + '\n')
        return action_all_str

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

    @staticmethod
    def get_dummy_action():
        """
            获取dummy action 的字符串返回
        """
        return DummyAction.format(1.0)
