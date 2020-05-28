import os

from plan2dance.Plan2Dance.action import SerialSort, ParallelSort, action_select, action_switch
from plan2dance.Plan2Dance.entity.music import Music
from plan2dance.Plan2Dance.common import ProjectPath, AboutClass
from plan2dance.Plan2Dance.planning_domain_definition_language import ActionResult
from plan2dance.Plan2Dance.music_analysis import segment, prepare_analysis
from plan2dance.Plan2Dance.config import IOConfig
from plan2dance.Plan2Dance.prepare import PopActionsDefine
import argparse

project_path = os.path.dirname(os.path.dirname(__file__))
pop_action_path = os.path.join(ProjectPath, "Data/Prepare/Action/PopAction")

pkl_tmp_dir = '/home/plan2dance/pkl'


def step_by_step(music_path, step):
    config = IOConfig().get_config()
    segment.get_one_minute_music(music_path)
    ms = Music(music_path, config)
    if step == 1:
        return ms
    ms.action_config = PopActionsDefine
    ms.action_path = pop_action_path
    segment.GetMusicSegment(ms).run()
    action_select.ActionSelect(ms).run()
    if step == 2:
        return ms
    plan_function = ms.Config["plan_function"]
    if plan_function == "parallel":
        # 4.1 使用并行进行求解
        print("Start parallel solution...")
        ParallelSort(ms).run()
    else:
        # 4.2 使用串行进行求解
        print("Start serial solution...")
        SerialSort(ms).run()
    if step == 3:
        return ms
    action_switch.SwitchToAction(ms).run()  # 转换为舞蹈文件
    return ms


def run_action_model(music_path):
    try:
        config = IOConfig().get_config()
        # 音乐切割
        segment.get_one_minute_music(music_path)
        ms = Music(music_path, config)
        pkl_path = os.path.join(pkl_tmp_dir, f"{ms.music_name}.pkl")
        AboutClass.save(pkl_path, ms)
        ar = ActionResult(pop_action_path)
        data = {
            'pkl_path': pkl_path,
            'basic_action': ar.get_common_action(),
            'dummy_action': ar.get_dummy_action()
        }
        return data
    except Exception as e:
        print(e)
        return False


def run_music_analysis(pkl_path, config):
    try:
        ms = AboutClass.read(pkl_path)
        print(pkl_path)
        # 赋值动作地址以及动作配置
        ms.action_config = PopActionsDefine
        ms.action_path = pop_action_path
        ms.set_config(config)
        classifier = config['classifier']
        if classifier == "yes":
            prepare_analysis.MusicAnalysis().run(is_restart=True)
        # 3、切割并分析输入音乐
        # 赋值 Music实体类三个属性music_time、beat_list、segment_result
        # 4、切割并分析输入音乐
        segment.GetMusicSegment(ms).run()
        # 5、为规划器选择高频动作，输出action_select.csv文件
        action_select.ActionSelect(ms).run()
        AboutClass.save(pkl_path, ms)
        data = {
            'segment_result': ms.segment_result
        }
        return data
    except Exception as e:
        print(e)
        return False


def run_planning_generation(pkl_path, config):
    try:
        ms = AboutClass.read(pkl_path)
        ms.set_config(config)
        plan_function = ms.Config["plan_function"]
        if plan_function == "parallel":
            # 4.1 使用并行进行求解
            print("Start parallel solution...")
            ParallelSort(ms).run()
        else:
            # 4.2 使用串行进行求解
            print("Start serial solution...")
            SerialSort(ms).run()
        AboutClass.save(pkl_path, ms)
        plan_list = ms.plan_list
        data = {
            'plan_list': plan_list
        }
        return data
    except Exception as e:
        print(e)
        return False


def run_generate_script(pkl_path):
    try:
        ms = AboutClass.read(pkl_path)
        # 7、转换规划解为机器人运行文件
        action_switch.SwitchToAction(ms).run()  # 转换为舞蹈文件
        data = {
            'ts': ms.MTNX_file
        }
        return data
    except Exception as e:
        print(e)
        return False


def main(args):
    """
        generate a dance script
        The result will point to ../Data/Result/output/music/*
        Params:
            music_path: path for your music

    """
    if args.music_path:
        music_path = args.music_path
    else:
        raise KeyError("Input your music path.")

    # Step 1
    config = IOConfig().get_config()
    ms = Music(music_path, config)
    # Step 2
    ms.action_config = PopActionsDefine
    ms.action_path = pop_action_path
    classifier = config['classifier']
    if classifier == "yes":
        prepare_analysis.MusicAnalysis().run(is_restart=True)
    segment.GetMusicSegment(ms).run()
    action_select.ActionSelect(ms).run()
    # Step 3
    plan_function = ms.Config["plan_function"]
    if plan_function == "parallel":
        # 4.1 使用并行进行求解
        print("Start parallel solution...")
        ParallelSort(ms).run()
    else:
        # 4.2 使用串行进行求解
        print("Start serial solution...")
        SerialSort(ms).run()
    # Step 4
    action_switch.SwitchToAction(ms).run()  # 转换为舞蹈文件

    # If you want to save entity of music.
    if args.pkl_path:
        pkl_path = args.music_path
        AboutClass.save(pkl_path, ms)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-m", "--music_path", help="path for your music")
    parser.add_argument("-p", "--pkl_path", help="Using pickle your music entity. Input your path")
    args = parser.parse_args()
    main(args)
