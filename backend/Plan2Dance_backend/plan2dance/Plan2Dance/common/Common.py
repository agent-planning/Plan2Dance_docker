import pickle
import os

ProjectPath = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))


class MusicResult(object):
    def __init__(self, name, message):
        self.name = name
        self.message = message

    def __str__(self):
        return self.message


class PlanResult(object):
    def __init__(self, seq, domain, problem, plan, repeat=0):
        self.seq = seq
        self.domain = domain
        self.problem = problem
        self.plan = plan
        self.success = True
        self.repeat = repeat

    def __str__(self):
        if self.success:
            return "Number {0} plan success!!!Plan: {1}".format(self.seq, self.plan)
        else:
            return "Number {0} plan error!!!Restart plan!!!".format(self.problem)


class AboutClass:
    def __init__(self):
        pass

    @staticmethod
    def save(path, ms):
        output_hal = open(path, 'wb')
        ms_str = pickle.dumps(ms)
        output_hal.write(ms_str)
        output_hal.close()

    @staticmethod
    def read(path):
        with open(path, 'rb') as file:
            ms = pickle.loads(file.read())
        return ms


def pickle_to_json(ms):
    """
        将音乐实体类转为json格式
    """
    data = {
        'segment_result': str(ms.segment_result),
        'plan_list': plan_result_to_json(ms.plan_list),
        'mtnx_file': ms.MTNX_file
    }
    return data


def plan_result_to_json(plan_list):
    data = {}
    for plan in plan_list:
        cur_data = {
            'seq': plan.seq,
            'domain': plan.domain,
            'problem': plan.problem,
            'plan': plan.plan,
            'success': plan.success,
            'repeat': plan.repeat,
        }
        data[plan.seq] = cur_data
    return data
