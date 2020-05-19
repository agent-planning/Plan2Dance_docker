y_state = ['forward', 'centre', 'backward']  # 向前， 中间， 向后
z_state = ['stand', 'half-squat', 'squat']  # 站立， 半蹲， 全蹲
hand_state = ["chest", 'others']  # 手部在胸前， 其他位置

TibetanActionsDefine = {
    'BackToBackSteps': {
        'hand_right_use': True,  # 执行过程用到右手
        'hand_left_use': True,  # 执行过程用到左手
        'leg_right_use': True,  # 执行过程用到右腿
        'leg_left_use': True,  # 执行过程用到左腿
        'start_space_y': y_state[0],  # 机器人身体倾斜状态
        'start_space_z': z_state[0],  # 机器人是否下蹲
        'start_hand_position': hand_state[1],  # 手的位置
        'end_space_y': y_state[0],  # 机器人身体倾斜状态
        'end_space_z': z_state[0],  # 机器人是否下蹲
        'end_hand_position': hand_state[1],  # 手的位置
        'time_change_allowed': False,  # 允许通过速率调整动作持续时间
        'coherent': ['TouchYourEars'],  # 后置固定动作组衔接
        'is_current_dance_type': True

    },
    'ClickStep': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': ['StringerPoint'],
        'is_current_dance_type': True
    },
    'KneeTrembling': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[0],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': ['ClickStep', 'SleeveThrowing'],
        'is_current_dance_type': True
    },
    'SleeveThrowing': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': ['TouchYourEars', 'BackToBackSteps'],
        'is_current_dance_type': True

    },
    'StepBack': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[0],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': True

    },
    'StringerPoint': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': False,
        'coherent': ['ThreeStepsOneStop'],
        'is_current_dance_type': True

    },
    'ThreeStepsOneStop': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': True

    },
    'TouchYourEars': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[0],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': False,
        'coherent': ['BackToBackSteps'],
        'is_current_dance_type': True

    },
    'HandsUpAndDown': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': True

    },
    'handsWaveDown': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': True,
        'coherent': [],
        'is_current_dance_type': False

    },
    'handsWaveUp': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': True,
        'coherent': [],
        'is_current_dance_type': False

    },
    'HandsUpDownRepeat': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[1],
        'end_hand_position': hand_state[1],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': False

    },
    'hitChest': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': False

    },
    'waveLeftAndRight': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[0],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': False

    },
    'saluteSwingArm': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[1],
        'end_space_y': y_state[0],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': False

    },
}
