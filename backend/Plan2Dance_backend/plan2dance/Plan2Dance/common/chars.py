DomainHeadStr = """(define (domain robot)
        ;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :typing :conditional-effects :equality :negative-preconditions :preferences :universal-preconditions)
(:types
    state rate space
    space_y space_z space_hand - space
)
"""

FuncAndPreStr = """(:predicates ;todo: define predicates here
    (is_body_free)
    (waiting ?s - state)
    (finished ?s - state)
    (best-rate ?s - state ?rate - rate)
    (at_space_y ?p - space_y) ; 以正视机器人为判断，则y轴表示身体前后的弯曲程度
    (at_space_z ?p - space_z) ; 以正视机器人为判断，则z轴表示身体上下的弯曲程度
    (at_hand ?s - space_hand)
)

(:functions ;todo: define numeric functions here
    (dance-time)
    (action-rate ?rate - rate)
    (action-times ?s - state)
    (at_floor_space) ; 机器人因为脚步动作造成的机器人在地面的位置偏移
    (control-transition)
    (dance-total-time) ; 哑动作时长
    (dummy-time)
    (dummy-total-time) ; 哑动作总时间
    (dummy-proportion) ; 哑动作占比
)
"""
ActionStr = """(:durative-action {0}
    :parameters (?rate - rate)
    :duration (= ?duration (* {4} (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            {2}
            (waiting {1})
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            {5}
        ))
        (at end (and 
            (increase (dance-time) (* {4} (action-rate ?rate)))
            (is_body_free)
            (finished {1})
            (best-rate {1} ?rate)
            (increase (action-times {1}) 1)
            {3}
        ))
    )
)
"""


initAction = """
(:durative-action initAction ;;初始动作
    :parameters ()
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (waiting s-init)
            (= (execute-times s-init) 0)
        ))
        (over all (and 
            (is_body_free hand-left) 
            (is_body_free hand-right)
            (is_body_free leg-left)
            (is_body_free leg-right)
        ))
    )
    :effect (and 
        (at start (and 
            (not (is_body_free hand-left))
            (not (is_body_free hand-right))
            (not (is_body_free leg-left))
            (not (is_body_free leg-right))
        ))
        (at end (and 
            (increase (execute-times s-init) 1)
            (increase (dance-time) 1) ;时间增加
            (is_body_free hand-left)
            (is_body_free hand-right)
            (is_body_free leg-left)
            (is_body_free leg-right)
            (finished s-init)
        ))
    )
)"""
DummyAction = """(:durative-action dummyAction
    :parameters ()
    :duration (= ?duration {0})
    :condition (and 
        (at start (and
            (is_body_free hand-left) 
            (is_body_free hand-right)
            (is_body_free leg-left)
            (is_body_free leg-right)
        ))
    )
    :effect (and   
        (at start (and
            (not (is_body_free hand-left))
            (not (is_body_free hand-right))
            (not (is_body_free leg-left))
            (not (is_body_free leg-right))
        ))
        (at end (and 
            (increase (dance-time) {0}) ;时间增加
            (increase (dummy-total-time) {0})
            (is_body_free hand-left)
            (is_body_free hand-right)
            (is_body_free leg-left)
            (is_body_free leg-right)
        ))
    )
)"""
SpecialDomainHeadStr = """(define (domain {0})
(:requirements :strips :fluents :durative-actions :typing :conditional-effects :equality :negative-preconditions :preferences :universal-preconditions :timed-initial-literals)
(:types
    beat
    state
    rate
    body-parts
    frequency
    space
    space-y space-z space-hand - space
)
"""

SpecialFuncAndPreStr = """
(:predicates ;todo: define predicates here
    (is_body_free ?bd - body-parts)  ; Represents physical resource constraints
    (waiting ?s - state)  ; Candidate Action
    (finished ?s - state) ; Completion of an action
    (at-body-space-y ?sy - space-y) ; Lean forward and back
    (at-body-space-z ?sz - space-z) ; Stand or squat
    (at-body-space-hand ?sh - space-hand) ; Arm position :Because the arm of the experimental robot is placed in front of the chest and there is a volume collision
    {0}
)

(:functions ;todo: define numeric functions here
    (dance-time)  ; Dance Time
    (execute-times ?s - state)  ; Number of Action performed
    (action-rate ?rate - rate)  ; Action Using Rate
    (high-frequency-times)  ; Number of high frequency actions performed
    (inter-frequency-times)  ; Number of intermediate frequency actions performed
    {1}
)"""

SpecialActionStr = """
(:durative-action {0}
    :parameters ({1})
    :duration (= ?duration {2})
    :condition (and 
        (at start (and 
            {3}
        ))
    )
    :effect (and 
        (at start (and
            {4}
        ))
        (at end (and 
            (increase (dance-time) {2})
            {5}
        ))
    )
)
"""

Header = """(define (problem {0}) 
(:domain robot)
(:objects
    slow - rate
    mid - rate
    fast - rate
)"""

InitStrFormat = """
(:init
    (is_body_free)
    (= (dance-time) 0)
    (= (action-rate slow) {0})
    (= (action-rate mid) {1})
    (= (action-rate fast) {2})
    (= (at_floor_space) 0)
    (= (control-transition) 0)
    {3}
)"""

# dummy action
InitStrFormatContainDummy = """
(:init
    (is_body_free)
    (= (dance-time) 0)
    (= (action-rate slow) {0})
    (= (action-rate mid) {1})
    (= (action-rate fast) {2})
    (= (dummy-total-time) 0)  ; Dummy Action time init
    (= (dummy-proportion) {4})  ; Dummy movement ratio
    {3}
)"""

InitState = """(at_space_y y_mid)
    (at_space_z z_up)
    (at_space_y y_front)
    (at_space_z z_down)
    (at_hand prethoracic)
    (at_hand others)
"""

InitActionStateUpdateFormat = "(waiting {0})\n"
InitActionTimesUpdateFormat = "(= (action-times {0}) 0)\n"
GoalStrFormat = """
(:goal (and
    {0}{1}{2}{3}
)
)"""

Metrics = """
(:metric minimize (+ {} 
    )
)
"""
StartPose = {
    'y_front': ['fastAdvance', 'leftHandsObliqueParallel', 'leftHandWave', 'leftPunch', 'leftSideKick',
                'leftTurn', 'mergeHand', 'parallelHandsAkimboErect', 'rightLean', 'sideMovement',
                'sidestepLeft', 'sitDown', 'splitLeap', 'takeTheLeft', 'rightHandFan', 'drumRoll', 'handAppearance',
                'handUpAndDown', 'heavyPendulum', 'leftRightWave', 'liftTheChest', 'raiseHandAndDropDown'],  # 前摆

    'y_mid': ['abandon', 'akimbo', 'akimboDown', 'akimboRaise', 'armsUpward', 'beatUpAndDown',
              'crossFingers', 'enlargeBosmHoodwink', 'hands_90', 'handsWaveDown', 'handsWaveUp', 'hitChest',
              'leftFuels', 'leftProtest', 'leftRightOut', 'leftRightRhythm', 'motionHands',
              'openHeartLeft', 'rightHandUp', 'runningMan', 'salute', 'shockHands', 'shockHandsToChest', 'takeTheLeft',
              'upwardPunches', 'finesseSwing', 'elbowTurn', 'handFly', 'rightSwing', 'rotatingRightHand',
              'scratchingHead', 'shakeHands', 'shoulderRhythm', 'spreadWings', 'twistWaist'],  # 中立

    'z_up': ['abandon', 'akimbo', 'akimboDown', 'akimboRaise', 'armsUpward', 'beatUpAndDown',
             'crossFingers', 'enlargeBosmHoodwink', 'hands_90', 'handsWaveDown', 'handsWaveUp', 'hitChest',
             'leftFuels', 'leftHandsObliqueParallel', 'leftProtest', 'leftRightOut', 'leftRightRhythm', 'motionHands',
             'openHeartLeft', 'fastAdvance', 'finesseSwing', 'leftHandWave', 'leftPunch', 'leftSideKick', 'leftTurn',
             'mergeHand', 'parallelHandsAkimboErect', 'rightHandFan', 'rightHandUp', 'rightLean', 'runningMan',
             'salute', 'shockHands', 'shockHandsToChest', 'sideMovement', 'sidestepLeft', 'sitDown', 'takeTheLeft',
             'takeTheLeft', 'upwardPunches', 'splitLeap', 'drumRoll', 'elbowTurn', 'handAppearance', 'handFly',
             'handUpAndDown', 'heavyPendulum', 'leftRightWave', 'liftTheChest', 'raiseHandAndDropDown',
             'rightSwing', 'rotatingRightHand', 'scratchingHead', 'shakeHands', 'shoulderRhythm', 'spreadWings',
             'twistWaist'],  # 直立
}
EndPose = {
    'y_front': ['fastAdvance', 'finesseSwing', 'hitChest', 'leftHandWave', 'leftPunch', 'leftSideKick', 'leftTurn',
                'mergeHand', 'rightHandFan', 'rightHandUp', 'shockHands', 'sideMovement', 'sidestepLeft',
                'takeTheLeft', 'midToFront', 'drumRoll', 'handAppearance', 'handUpAndDown', 'leftRightWave',
                'liftTheChest', 'raiseHandAndDropDown', 'twistWaist'],  # 前摆

    'y_mid': ['abandon', 'akimbo', 'akimboDown', 'akimboRaise', 'armsUpward', 'beatUpAndDown',
              'crossFingers', 'hands_90', 'handsWaveDown', 'handsWaveUp', 'leftFuels', 'leftProtest',
              'leftRightRhythm', 'motionHands', 'openHeartLeft', 'leftHandsObliqueParallel', 'leftRightOut',
              'parallelHandsAkimboErect', 'rightHandFan', 'rightLean', 'runningMan', 'salute', 'shockHandsToChest',
              'sitDown', 'splitLeap', 'splitLeap', 'takeTheLeft', 'upwardPunches', 'frontToMid', 'downToUp',
              'upToDown', 'parallelHands', 'enlargeBosmHoodwink', 'elbowTurn', 'handFly', 'heavyPendulum',
              'rightSwing', 'rotatingRightHand', 'scratchingHead', 'shakeHands', 'spreadWings', 'shoulderRhythm'],  # 中立

    'z_up': ['abandon', 'akimbo', 'akimboDown', 'akimboRaise', 'armsUpward', 'beatUpAndDown',
             'crossFingers', 'hands_90', 'handsWaveDown', 'handsWaveUp', 'hitChest', 'leftFuels',
             'leftHandsObliqueParallel', 'leftProtest', 'leftRightRhythm', 'motionHands', 'openHeartLeft',
             'fastAdvance', 'finesseSwing', 'leftHandWave', 'leftPunch', 'leftSideKick', 'leftTurn', 'mergeHand',
             'parallelHandsAkimboErect', 'rightHandUp', 'rightLean', 'runningMan', 'salute', 'shockHandsToChest',
             'sideMovement', 'sidestepLeft', 'splitLeap', 'takeTheLeft', 'takeTheLeft', 'upwardPunches', 'midToFront',
             'frontToMid', 'downToUp', 'rightHandFan', 'parallelHands', 'drumRoll', 'elbowTurn', 'handAppearance',
             'handFly', 'handUpAndDown', 'heavyPendulum', 'leftRightWave', 'liftTheChest', 'raiseHandAndDropDown',
             'rightSwing', 'rotatingRightHand', 'scratchingHead', 'shakeHands', 'shoulderRhythm',
             'spreadWings', 'twistWaist', 'shockHands'],  # 直立
    'z_down': ['enlargeBosmHoodwink', 'sitDown', 'leftRightOut', 'upToDown'],  # 深蹲
}
# show hand position
HandsPosition = ['beatUpAndDown', 'leftHandsObliqueParallel']
# 表示机器人移动的位置
ActionFloor = {
    'leftFuels': 9,
    'leftSideKick': 3.6,
    'leftTurn': 5.6,
    'sideMovement': 11.25,

}
# 过渡动作PDDL
ActionTransition = """
; The transition action : Backward to Centre
(:durative-action BackwardToCentre
    :parameters ()
    :duration (= ?duration 0.5)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y backward))
            (not (at-body-space-z stand))
        ))
        (at end (and 
            (increase (dance-time) 0.5)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
        ))
    )
)
; The transition action : Centre to Backward
(:durative-action centreToBackward
    :parameters ()
    :duration (= ?duration 0.5)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
        ))
        (at end (and 
            (increase (dance-time) 0.5)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
        ))
    )
)
; The transition action : Centre to Forward
(:durative-action centreToForward
    :parameters ()
    :duration (= ?duration 0.5)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
        ))
        (at end (and 
            (increase (dance-time) 0.5)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
        ))
    )
)

; The transition action : Forward to Centre
(:durative-action forwardToCentre
    :parameters ()
    :duration (= ?duration 0.5)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))            
        ))
        (at end (and 
            (increase (dance-time) 0.5)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)            
        ))
    )
)
; The transition action :Half-Squat to Stand
(:durative-action halfSquatToStand
    :parameters ()
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z half-squat))
        ))
        (at end (and 
            (increase (dance-time) 1)
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (at-body-space-y centre)
            (at-body-space-z stand)
        ))
    )
)
; The transition action : Stand to Half-Squat
(:durative-action StandToHalfSquat
    :parameters ()
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
        ))
        (at end (and 
            (increase (dance-time) 1)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
        ))
    )
)

; The transition action : Hand to others(not close chest)
(:durative-action handToOthers
    :parameters ()
    :duration (= ?duration 0.4)
    :condition (and 
        (at start (and
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-hand chest))
            ))
        (at end (and 
            (increase (dance-time) 0.4)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-hand others)
        ))
    )
)
"""
