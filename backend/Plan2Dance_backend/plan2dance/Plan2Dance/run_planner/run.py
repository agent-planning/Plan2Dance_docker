"""
    本文件为规划器运行类
"""
import os
import subprocess
import re
from plan2dance.Plan2Dance.common import ProjectPath


class RunPlanner:
    """
        运行规划器
    """

    def __init__(self, domain_file_path, problem_path, solution_file_name, time_restrict):
        self.solution_file_name = solution_file_name
        self.domain_file_path = domain_file_path
        self.problem_file_path = problem_path
        self.time_restrict = int(time_restrict)

    @staticmethod
    def get_solution_time(content):
        """
            获取解中的时间
        """
        pattern = r'; Time\s\d+.\d+'
        res = re.findall(pattern, content)

        # print("Plan Found;\nTime: ", res[-1].split(' ')[-1], ";")
        return res[-1]

    def check_plan(self, solution_file_name):
        """
        读取文件位置，搜寻其中是否包含解文件
        对于optic有两种情况：
            1、";;;; Solution Found"，存在完全解
            2、"; Plan found"，存在次优解（当时间超过20s后，程序自动停止，然后输出次优解到文件中）
        直接正则按照规划解的格式，匹配到的字符位于列表中，找到列表中的各个解的开头，计数，最后循环列表，拿到最后一个解就是我们所要的解
        :param solution_file_name: 解存放位置
        :return: 求解后的文件字符串
        """
        with open(solution_file_name, 'r') as f:
            lines = f.read()
        pattern = r'\d+\.\d+:\s\(.*?\)\s+\[\d+\.\d+\]'  # 匹配一行的解
        start_point = r'0\.000:'  # 匹配解的开头
        res = re.findall(pattern, lines)  # 找到所有plan计划
        time_str = self.get_solution_time(lines)
        times = len(re.findall(start_point, lines))  # 记录plan的开头
        result = []
        num = 0
        result_str = time_str + "\n"
        # 找到plan的结果，然后放到一个列表里面
        for index, line in enumerate(res):
            check = re.match(start_point, line)
            if check:
                num += 1
                if num == times:
                    result = res[index:]
                    break
        # # 拼接为一串字符串
        for l in result:
            result_str += (l + '\n')
        with open(solution_file_name, 'w') as f:
            f.write(result_str)
        return True

    def run_optic(self):
        """
        使用optic-clp规划器
        PS：该规划器是局限版，支持偏好
        不过所能使用的偏好函数较少，但其使用了partial-order替换了total-order，相对而言解的规律相对另外两个不一样
        :return: True or False ，表示是否有解
        """
        self.run_planner()
        result = False
        repeat = 1
        while not result:
            # 解析出解再放进去
            with open(self.solution_file_name, 'r') as f:
                plan_content = f.read().strip()
            if ";;;; Solution Found" in plan_content:
                result = self.check_plan(self.solution_file_name)
            elif "; Plan found" in plan_content:
                result = self.check_plan(self.solution_file_name)
            else:
                if os.path.exists(self.solution_file_name):
                    os.remove(self.solution_file_name)  # 删除文件
                result = False
            # 结果判断
            if result:
                # print("Solution exist!!!\nSolution Path: {0}\n".format(self.solution_file_name))
                break
            else:
                print("Solution not exist, restart!!!")
                # 重复4次加时限之后不行就退出程序说明此问题
                if repeat == 1:
                    self.time_restrict += 20
                elif repeat == 2:
                    self.time_restrict += 40
                elif repeat >= 3 and repeat < 5:
                    self.time_restrict += 60
                else:
                    raise TimeoutError(
                        "The current time limit is {} and it has been weighted 4 times".format(self.time_restrict))
                self.run_planner()
                repeat += 1
        return result

    def run_planner(self, ):
        # 生成solution文件夹，每个problem对应一个
        shell_1 = "cd {}/Plan2Dance/run_planner/planner/optic-clp".format(ProjectPath)
        shell_2 = "timeout {3} ./optic-clp {0} {1} >{2}".format(self.domain_file_path, self.problem_file_path,
                                                                self.solution_file_name, self.time_restrict)
        shell = shell_1 + " && " + shell_2
        subprocess.call(shell, shell=True)
