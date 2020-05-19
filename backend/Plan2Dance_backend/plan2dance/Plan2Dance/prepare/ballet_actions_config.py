y_state = ['forward', 'centre', 'backward']  # 向前， 中间， 向后
z_state = ['stand', 'half-squat', 'squat']  # 站立， 半蹲， 全蹲
hand_state = ["chest", 'others']  # 手部在胸前， 其他位置

BalletActionsDefine = {
    'AfterWipe': {
        'hand_right_use': True,  # 执行过程用到右手
        'hand_left_use': True,  # 执行过程用到左手
        'leg_right_use': True,  # 执行过程用到右腿
        'leg_left_use': True,  # 执行过程用到左腿
        'start_space_y': y_state[1],  # 机器人身体倾斜状态
        'start_space_z': z_state[0],  # 机器人是否下蹲
        'start_hand_position': hand_state[0],  # 手的位置
        'end_space_y': y_state[1],  # 机器人身体倾斜状态
        'end_space_z': z_state[0],  # 机器人是否下蹲
        'end_hand_position': hand_state[0],  # 手的位置
        'time_change_allowed': False,  # 允许通过速率调整动作持续时间
        'coherent': [],  # 后置固定动作组衔接
        'is_current_dance_type': True
    },
    'Alabez': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[0],
        'end_space_z': z_state[1],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': ['AfterWipe'],
        'is_current_dance_type': True
    },
    'FrontLegLift': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[0],
        'start_space_z': z_state[1],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[0],
        'end_space_z': z_state[1],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': ['Alabez'],
        'is_current_dance_type': True
    },
    'FrontWipe': {
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
        'coherent': ['HandPointFour', 'HandPointOne', 'HandsExchange'],
        'is_current_dance_type': True
    },
    'HandPointFour': {
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
        'coherent': ['HandPointOne', 'FrontWipe', 'PointOne'],
        'is_current_dance_type': True
    },
    'HandPointOne': {
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
        'coherent': ['FrontWipe', 'HandPointFour', 'saluteSwingArm'],
        'is_current_dance_type': True
    },
    'HandsExchange': {
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
        'coherent': ['HandPointFour', 'FrontWipe', 'HandPointFour', 'PointOne'],
        'is_current_dance_type': True
    },
    'PointFour': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[2],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[2],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': True
    },
    'PointOne': {
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
        'is_current_dance_type': True
    },
    'PointOneToPointSeven': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[1],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': True
    },
    'PointThree': {
        'hand_right_use': True,
        'hand_left_use': True,
        'leg_right_use': True,
        'leg_left_use': True,
        'start_space_y': y_state[1],
        'start_space_z': z_state[0],
        'start_hand_position': hand_state[0],
        'end_space_y': y_state[1],
        'end_space_z': z_state[0],
        'end_hand_position': hand_state[0],
        'time_change_allowed': False,
        'coherent': [],
        'is_current_dance_type': True
    },
    'PointTwo': {
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
    'akimbo': {
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
}
