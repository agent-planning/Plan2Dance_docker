import sys
import os
import re
import copy
from plan2dance.Plan2Dance.common import ProjectPath

"""
将规划解转换为mtnx文件输出
"""


class SwitchToAction:
    def __init__(self, ms):
        self.ms = ms
        self.action_config = ms.action_config
        config = self.ms.Config
        self.planner = config['planner']
        self.dummy_time = 1.0
        self.dummy_index = 0
        self.pre_action_last_pose = str()
        self.action_dir_path = ms.action_path
        self.relation_dir_path = os.path.join(ProjectPath, 'Data/Prepare/Relation')
        self.solution_path = ms.solution_dir_path
        self.solution_str = str()
        self.result = str()
        self.start_time = 0.000
        self.output_dir_path = ms.plan_dir_path
        self.action_time = {}
        self.action_pages_dict = {}
        self.action_dummy_pages = {}
        self.action_units_list = []
        self.actions_list = os.listdir(self.action_dir_path)

    @staticmethod
    def __change_page_name(page_content, change_name):
        """
            修改page中的动作名字
        """

        def _replace_name_str(matched):
            """
            change the frame number
            :param matched:
            :return:
            """
            cur_action_name = matched.group()
            cur_pattern_page_name = re.compile("name=\"(.+?)\"")
            old_action_name = cur_pattern_page_name.findall(cur_action_name)[0]
            new_name_content = re.sub(r'.+', change_name, old_action_name)
            return "name=\"{}\"".format(new_name_content)

        # 3、通过change_name修改page中的动作名
        pattern = "name=\"(.+?)\""
        update_name_content = re.sub(pattern, _replace_name_str, page_content)
        return update_name_content

    def __get_action_upper_name(self, name):
        """
            拿到该动作的驼峰命名的名字（文件夹中存在的）
        """
        upper_name = str()
        for action in self.actions_list:
            action_name = action.split('.')[0]
            if action_name.lower() == name.lower():
                upper_name = action_name
                break
        if not upper_name:
            assert "Action not Exist"
        return upper_name

    @staticmethod
    def __get_part_page(content):
        """
            拿出MTNX动作其中的page部分
        """
        pattern_page = re.compile('<Page .+</Page>', re.S)
        res = pattern_page.search(content)
        page_content = res.group()
        return page_content

    def __get_action_page(self, name, scale, change_name):
        """
            得到更新完frame后的动作page部分内容
        :param name:
        :param scale:
        :return:
        """
        upper_name = self.__get_action_upper_name(name)

        def _replace_scale_str(matched):
            """
            change the frame number
            :param matched:
            :return:
            """
            int_str = matched.group()
            num = re.findall(r'\d+', int_str)[0]
            int_value = int(num)
            added_value = int(int_value * scale)  # 误差修正(软件本身存在一定的动作执行误差)
            added_value_str = re.sub(r'\d+', str(added_value), int_str)
            return added_value_str

        mtnx_path = os.path.join(self.action_dir_path, "{}.mtnx".format(upper_name))
        with open(mtnx_path, 'r', encoding='utf-8') as f:
            f_read = f.read()
        # 1、通过scale修改frame
        pattern = r'frame="\d+"'  # get the frame info which about the action time
        update_frame_content = re.sub(pattern, _replace_scale_str, f_read)
        # 2、拿到其中的page部分
        page_content = self.__get_part_page(update_frame_content)
        # 3、修改main名字
        update_name_content = self.__change_page_name(page_content, change_name)
        return update_name_content

    def __get_action_last_pose(self, action_name):
        """
            根据动作名字获取其最后一个pose
        """
        with open(os.path.join(self.action_dir_path, "{}.mtnx".format(action_name)), 'r', encoding='utf-8') as f:
            f_read = f.read()
        # 1、通过scale修改frame
        pattern = r'<step frame="\d+" .*? />'
        res = re.findall(pattern, f_read)
        return res[-1]

    def __update_dummy_action(self, dummy_action_name, pre_action_name):
        """
            根据dummyAction的名字和unit中前一个动作的名字获取到新dummy动作的名称
            return: page_content 动作的page部分内容
        """
        name = "dummyAction"  # 直接拿到dummy的文件

        dummy_action_time = int(self.dummy_time * 128)  # 哑动作持续时间
        # 1、获取到前一个动作的最后一个psoe
        pre_action_last_pose = self.__get_action_last_pose(pre_action_name)

        # print(pre_action_last_pose)

        def _replace_str(matched):
            """
            change the frame number
            :param matched:
            :return:
            """
            int_str = matched.group()
            added_value_str = re.sub(r'\d+', str(dummy_action_time), int_str)
            return added_value_str

        with open(os.path.join(self.action_dir_path, "{}.mtnx".format(name)), 'r', encoding='utf-8') as f:
            # 2、更换为前一个动作的pose
            pattern = r'<step frame="128" pose="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" />'
            content = re.sub(pattern, pre_action_last_pose, f.read())
        # 3、修改一个dummy动作的持续时间
        pattern = r'frame="\d+"'  # get the frame info which about the action time
        res = re.sub(pattern, _replace_str, content)
        # 4、更新其动作名称
        update_name_content = self.__change_page_name(res, dummy_action_name)
        # 5、拿到其page部分
        page_content = self.__get_part_page(update_name_content)

        return dummy_action_time, page_content

    def __update_actions(self):
        self.__update_action_units()  # 更新pages
        self.__update_action_pages()  # 更新units
        # 合并dummy进入page中
        cur_action_pages = copy.copy(self.action_pages_dict)
        self.action_pages_dict = {**cur_action_pages, **self.action_dummy_pages}

    def __get_name_from_mtnx(self, name):
        upper_name = self.__get_action_upper_name(name)
        mtnx_path = os.path.join(self.action_dir_path, "{}.mtnx".format(upper_name))
        with open(mtnx_path, 'r', encoding='utf-8') as f:
            f_read = f.read()
        page_content = self.__get_part_page(f_read)
        pattern = "name=\"(.+?)\""
        matched = re.compile(pattern, re.S)
        result = matched.search(page_content)
        cur_action_name = result.group()
        cur_pattern_page_name = re.compile("name=\"(.+?)\"")
        old_action_name = cur_pattern_page_name.findall(cur_action_name)[0]
        return old_action_name

    def __update_action_pages(self):
        """
            生成新的page
        """
        cur_actions_pages = copy.copy(self.action_pages_dict)
        for action_name, action_config in cur_actions_pages.items():
            name = action_name.split(' ')[0]
            new_name = self.__get_new_name(action_name)
            scale = action_config['scale']
            # 拿到当前动作修改后的动作
            page_content = self.__get_action_page(name, scale, new_name)  # 拿到修改后的动作内容
            # 将page_content加进字典的对应动作
            # page还需要修改unit的部分
            self.action_pages_dict[action_name]['action_page'] = page_content
            if action_name != new_name:
                self.action_pages_dict[new_name] = self.action_pages_dict[action_name]
                self.action_pages_dict.pop(action_name)

    def __get_new_name(self, name):
        res = name.split(' ')
        name = res[0]
        if len(res) == 1:
            new_name = self.__get_name_from_mtnx(name)
        else:
            rate = res[1]
            new_name = "{0} {1}".format(self.__get_name_from_mtnx(name), rate)

        return new_name

    def __update_action_units(self):
        """
            更新units
                如果遇到dummyAction，那么就要拿到其前面一个动作，然后组成一个新的动作，记录到dummy列表中，后面添加到page中去
        """
        # print(self.action_units_list)
        flow_unit_format = '<unit main="{0}" mainSpeed="1" loop="{1}" exit="" exitSpeed="1" callSite="False" />'
        cur_actions_units = copy.copy(self.action_units_list)
        before_action = None
        for index, action in enumerate(cur_actions_units):
            action_name = action['action_name']
            action_loop = action['action_loop']
            if action_name.lower() == "dummyaction":
                # 这个时候就要拿到前一个的动作
                pre_action = before_action
                pre_action_name = self.__get_action_upper_name(pre_action.split(' ')[0].split('_')[0])
                dummy_action_name = self.__add_dummy_action_to_dict(pre_action_name)  # 将dummy动作添加到pages中
                flow_unit = flow_unit_format.format(dummy_action_name, action_loop)
                self.action_units_list[index]['action_name'] = dummy_action_name  # 修改名字
                self.action_units_list[index]['action_unit'] = flow_unit  # 添加unit内容
            else:
                new_name = self.__get_new_name(action_name)
                flow_unit = flow_unit_format.format(new_name, action_loop)
                self.action_units_list[index]['action_name'] = new_name
                self.action_units_list[index]['action_unit'] = flow_unit

            before_action = action_name

    def __add_dummy_action_to_dict(self, pre_action_name):
        """
            根据units的信息来添加dummy新动作
            判断是否存在，不存在则新增，存在则直接返回
            pre_action: 前面动作的参数
            return : 当前的名字
        """
        # 存在dummy动作，判断是否有重复
        if self.dummy_index != 0:
            point = self.dummy_index - 1
            flag = False
            cur_dummy_action_name = None
            while True:
                if point == -1:
                    break
                cur_dummy_action_name = "Dummy Action {}".format(int(point))
                action_time, page_content = self.__update_dummy_action(cur_dummy_action_name, pre_action_name)
                cur_page_content = self.action_dummy_pages[cur_dummy_action_name]['action_page']
                if cur_page_content == page_content:
                    flag = True
                point -= 1

            if flag:
                return cur_dummy_action_name

        # 1、定义一个新名字
        dummy_action_name = "Dummy Action {}".format(self.dummy_index)
        # 2、根据新名字和前一个动作对其进行修改
        action_time, page_content = self.__update_dummy_action(dummy_action_name, pre_action_name)

        config = {
            'action_time': action_time,
            'action_rate': None,
            'scale': 1.0,
            'action_page': page_content
        }
        # 3、添加动作page的字典中
        self.action_dummy_pages[dummy_action_name] = config
        # 4、返回新名字
        self.dummy_index += 1
        return dummy_action_name

    def __get_mtnx_head_and_bottom(self):
        head = open(os.path.join(self.relation_dir_path, 'headAction'), 'r').read()
        bottom = open(os.path.join(self.relation_dir_path, 'bottomAction'), 'r').read()
        return head, bottom

    def __generate_mtnx(self):
        """
            根据pages字典和units列表生成新动作
        """
        # 1、获取头部和底部文件
        head, bottom = self.__get_mtnx_head_and_bottom()
        # 2、拼接FlowRoot中的units
        flow_root_format = '<FlowRoot>\n<Flow name="dance" return="-1">\n<units>\n{0}</units>\n</Flow>\n</FlowRoot>\n'
        all_units = str()
        for unit_action in self.action_units_list:
            unit_action_str = "\t" + unit_action['action_unit'] + "\n"
            all_units += unit_action_str
        flow_root = flow_root_format.format(all_units)
        # 3、拼接PageRoot中的pages
        page_root_format = "<PageRoot>\n{0}\n</PageRoot>"
        all_pages = str()
        for _, page_action_config in self.action_pages_dict.items():
            action_page = "\t" + page_action_config['action_page'] + "\n"
            all_pages += action_page
        page_root = page_root_format.format(all_pages)
        # 4、拼接
        self.result = head + flow_root + page_root + bottom

    def __get_action_time(self, action_name):
        """
        获取动作的时长
        :param action_name: 动作名称
        :return:
        """
        actions = os.listdir(self.action_dir_path)
        for action in actions:
            cur_action = action.split('.')[0]
            if action_name.lower() == cur_action.lower():
                # if action_name == "dummyaction":
                #     print(cur_action)
                action_name = cur_action
                break
        if action_name in self.action_time.keys():
            return self.action_time[action_name]
        else:
            path = os.path.join(self.action_dir_path, '{}.mtnx'.format(action_name))
            with open(path, 'r', encoding='utf-8') as f:
                action_content = f.read()
            frame = re.findall(r'frame="\d+"', action_content)[-1]
            frame = re.findall(r'\d+', frame)[0]
            time = round(float(frame) / 128, 3)
            self.action_time[action_name] = time
            return time

    def __init_actions_scale(self):
        """
        At first, scale = old time / new time,through the scale to change the frame number
        :return:
        """
        cur_action_list = copy.copy(self.action_pages_dict)
        for action_all_name, action_config in cur_action_list.items():
            action_name = action_all_name.split(' ')[0]  # 实际动作名称
            if self.__check_action(action_name):
                # 会出现速率变化
                action_before_time = self.__get_action_time(action_name)  # 原本动作的时长
                action_after_time = action_config['action_time']
                scale = round(action_after_time / action_before_time, 3)  # old time/new time
            else:
                scale = 1.0  # 速率不会变化
            self.action_pages_dict[action_all_name]['scale'] = scale

    def __save_to_output(self):
        # with open(self.ms.final_plan_path, 'w', encoding='utf-8') as f:
        #     f.write(self.solution_str)
        # print("=============The Final Solution==============\n", self.solution_str)
        # print("Solution Saved Path: ", self.ms.final_plan_path)

        self.ms.MTNX_file = self.result
        # with open(self.ms.mtnx_path, 'w', encoding='utf-8') as f:
        #     f.write(self.result)
        # print("MTNX Saved Path: ", self.ms.mtnx_path)

    @staticmethod
    def __mirror_pose(content):
        """
        动作镜像转换
        :param content: 动作文件读取内容
        :return: 镜像后的文件，左右翻转
        """

        def change_dynamixel(pose):
            cur_pose = re.compile("pose=\"(.+?)\"")
            cur_str = cur_pose.findall(pose)[0]
            cur_list = cur_str.split(' ')
            result = str()
            cur_list = [float(param) for param in cur_list]
            for i in range(0, len(cur_list), 2):
                # 交换值
                if cur_list[i] >= 0:
                    if cur_list[i + 1] >= 0:
                        cur_list[i], cur_list[i + 1] = cur_list[i + 1], cur_list[i]
                    else:
                        cur_list[i], cur_list[i + 1] = abs(cur_list[i + 1]), - cur_list[i]
                else:
                    if cur_list[i + 1] >= 0:
                        cur_list[i], cur_list[i + 1] = - cur_list[i + 1], abs(cur_list[i])
                    else:
                        cur_list[i], cur_list[i + 1] = cur_list[i + 1], cur_list[i]

            for i, p in enumerate(cur_list):
                if i == len(cur_list) - 1:  # 最后一个不加\n
                    result += (str(p))
                else:
                    result += (str(p) + " ")

            return 'pose="{}"'.format(result)

        def _replace_str(matched):
            rr = matched.group()
            # addedValueStr = re.sub(r'\d+', str(addedValue), intStr)
            new_rr = change_dynamixel(rr)
            return new_rr

        pattern = r'pose=".*?"'
        res = re.sub(pattern, _replace_str, content)
        return res

    def __check_action(self, action_name):
        """
            通过动作名称，判断动作是否需要改变：rate
            所以只需要拿到动作名称和速率就可以了

        """
        upper_name = self.__get_action_upper_name(action_name)
        if upper_name in self.action_config.keys():
            time_change_allowed = self.action_config[upper_name]['time_change_allowed']
            if time_change_allowed:
                # 处理后面的速度参数，动作名字后面的那个
                return True
        return False

    # 以下add开头为由多个解中拿到其中的动作单元组成action_pages_dict和action_units_list
    def __add_not_exist_actions(self, action_name, action_time, action_rate):
        """
            动作完全不存在:
                那么判断速率是否可用，然后生成新的动作名称记录使用
        """
        if action_rate:  # 如果允许使用速率
            # 新建一个
            config = {
                'action_time': action_time,
                'action_rate': action_rate,
            }
            new_action_name = "{0} {1}".format(action_name, action_rate)
        else:  # 不允许使用速率
            config = {
                'action_time': action_time,
                'action_rate': False
            }
            new_action_name = action_name
        unit_action = {
            'action_name': new_action_name,
            'action_loop': 1,
        }
        self.action_units_list.append(unit_action)  # 放入动作单元表明循环顺序以及次数
        self.action_pages_dict[new_action_name] = config  # 放入动作字典，定义每个动作的配置

    def __add_exist_actions(self, action_name, action_time, action_rate):
        """
            支持速率的动作处理
        """
        new_action_name = "{0} {1}".format(action_name, action_rate)
        unit_action = {
            'action_name': new_action_name,
            'action_loop': 1,
        }
        config = {
            'action_time': action_time,
            'action_rate': action_rate,
        }
        # 判断动作全名是否存在
        if new_action_name in self.action_pages_dict.keys():
            # 判断当前与前一个是否一致，如果一致，那么循环+1
            if self.action_units_list[-1]['action_name'] == action_name:  # 相同，那么循环 +1
                self.action_units_list[-1]['action_loop'] += 1
            else:
                self.action_units_list.append(unit_action)
        else:  # 不存在，新建一个
            # 新建一个
            self.action_units_list.append(unit_action)
            self.action_pages_dict[new_action_name] = config

    def __add_action_to_dict(self, action_name, action_time, action_rate=None):
        """
            添加动作到字典中，如果速率不一样那就重新生成一个
            1、区分是否存在：两种
            2、区分是否支持速率
        """
        cur_actions = [action.split(' ')[0] for action in self.action_pages_dict.keys()]  # 提取出动作
        if action_name not in cur_actions:
            # 如果名字不在动作列表中，需要添加
            self.__add_not_exist_actions(action_name, action_time, action_rate)
        else:
            # 单个动作在列表中，然后开始判断动作全名
            # 判断速率是否一致，然后决定新建或者循环+1
            if not action_rate:
                # 不支持速率(不需要新建)
                # 判断是循环 + 1还是新建一个
                if self.action_units_list[-1]['action_name'] == action_name:  # 相同，那么循环 +1
                    self.action_units_list[-1]['action_loop'] += 1
                else:
                    unit_action = {
                        'action_name': action_name,
                        'action_loop': 1,
                    }
                    self.action_units_list.append(unit_action)
                    # self.action_pages_dict[action_name]['action_loop'] += 1
            else:  # 支持速率
                self.__add_exist_actions(action_name, action_time, action_rate)

    def _get_salute_str(self):
        """
            获取对应动作库中的行礼动作
        """
        salute_time = self.__get_action_time("salute")
        salute_str = "0.000: (salute)  [{}]".format(float(salute_time))
        return salute_str

    def __init_action_list_by_plan(self):
        """
            根据文件中所有的plan得到相关动作信息
        """
        path = self.solution_path
        plan_time_cost = 0
        plan_list = os.listdir(path)
        plan_list.sort(key=lambda x: int(x.split('_')[1]))
        cur_plan_list = []
        self.solution_str = str()  # 重置solution
        for index, plan in enumerate(plan_list):
            # 定义结果地址
            plan_path = os.path.join(path, plan)
            arr = []  # 重置列表
            with open(plan_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
                cur_time = float(lines[0].split(' ')[-1])
                plan_lines = lines[1:]
                for line in plan_lines:
                    res = line.strip('\n')
                    arr.append(res)
            plan_time_cost += cur_time
            # 开始单独处理出解来
            # 添加结尾行礼动作
            if index == len(plan_list) - 1:
                salute_str = self._get_salute_str()
                arr.append(salute_str)
            for j, res in enumerate(arr):
                action = res.split(' ')
                # 判断是否为重复选项，如果是则拿出动作和时间
                action_all_name = action[1].replace('(', '').replace(')', '')
                action_name = action_all_name.split('_')[0]
                # 第一个动作是dummy的话跳过
                if action_name.lower() == "dummyaction" and j == 0:
                    continue
                # 取出plan中间动作
                action_str = ""
                actions_list = action[1:-1]
                for index, value in enumerate(actions_list):
                    if index != len(actions_list) - 1:
                        action_str += "{} ".format(value)
                    else:
                        action_str += "{}".format(value)
                action_time = float(action[-1].replace('[', '').replace(']', ''))
                current_str = "{0}: {1} [{2}]\n".format(self.start_time, action_str, action_time)

                action_rate = None  # 赋予初始值
                if self.__check_action(action_name):
                    # 有速率
                    action_rate = action[2].replace(')', '')
                self.__add_action_to_dict(action_name, action_time, action_rate)  # 判断动作

                self.start_time += action_time
                self.solution_str += current_str
                cur_plan_list.append(current_str)
        self.ms.final_plan = cur_plan_list
        self.ms.real_plan_time_cost = plan_time_cost  # 记录真正的规划计算时间
        print("All Plan Time Cost:", plan_time_cost)

    def run(self):
        # 1、由解中拿到动作列表
        self.__init_action_list_by_plan()
        # 2、确定每个动作时间的scale变化
        self.__init_actions_scale()
        # 3、更新动作的page和units
        self.__update_actions()
        # 4、生成mtnx文件
        self.__generate_mtnx()
        # 5、保存结果
        self.__save_to_output()
