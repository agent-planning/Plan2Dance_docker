"""
    读取配置
"""
import os
from configparser import ConfigParser
from plan2dance.Plan2Dance.common import ProjectPath

path = os.path.join(ProjectPath, 'Plan2Dance/config/Plan2Dance.cfg')


class IOConfig:

    def __init__(self):
        self.config = {}
        self._init_config()

    def _init_config(self):
        cf = ConfigParser()
        cf.read(path, encoding='UTF-8')
        boolean = cf.has_section("config")
        config_list = dict()
        if boolean:
            try:
                for key in cf['config']:
                    config_list[key] = cf['config'][key]
                self.config = config_list
            except KeyError as ke:
                assert ke
        # print(config_list)

    def get_config(self):
        return self.config

    @staticmethod
    def set_config(data: dict):
        cf = ConfigParser()
        cf.read(path, encoding='UTF-8')
        for name, value in data.items():
            if name in cf['config'].keys():
                cf.set("config", name, value)
            else:
                raise KeyError("{} not exist in the config.".format(name))
        with open(path, "w+", encoding='UTF-8') as f:
            cf.write(f)
        return True