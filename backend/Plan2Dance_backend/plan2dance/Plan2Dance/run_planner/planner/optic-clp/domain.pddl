(define (domain robot)
        ;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :typing :conditional-effects :equality :negative-preconditions :preferences :universal-preconditions)
(:types
    state rate space
    space_y space_z space_hand - space
)
(:constants
            s1	s2	s3	s4	s5	 - state
s6	s7	s8	s9	s10	 - state
s11	s12	s13	s14	s15	 - state
s16	s17	s18	s19	s20	 - state
s21	s22	s23	s24	s25	 - state
s26	s27	s28	s29	s30	 - state
s31	s32	s33	s34	s35	 - state
s36	s37	s38	s39	s40	 - state
s41	s42	s43	 - state

y_front y_mid - space_y
z_up z_down - space_z
prethoracic others - space_hand

)
(:predicates ;todo: define predicates here
    (is_body_free)
    (waiting ?s - state)
    (finished ?s - state)
    (best-rate ?s - state ?rate - rate)
    (at_space_y ?p - space_y) ;;以正视机器人为判断，则y轴表示身体前后的弯曲程度
    (at_space_z ?p - space_z) ;;以正视机器人为判断，则z轴表示身体上下的弯曲程度
    (at_hand ?s - space_hand)
)

(:functions ;todo: define numeric functions here
    (dance-time)
    (action-rate ?rate - rate)
    (action-times ?s - state)
    (at_floor_space) ;;机器人因为脚步动作造成的机器人在地面的位置偏移
    (control_the_transition)
    (all_action_times)
)

(:durative-action midToFront
    :parameters (?rate - rate)
    :duration (= ?duration 0.5)
    :condition (and 
        (at start (and
            (at_space_y y_mid)
            (at_space_z z_up)
            (is_body_free)
            (< (all_action_times) 1)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
            (not (at_space_z z_up))
        ))
        (at end (and 
            (increase (dance-time) 0.5) ;时间增加
            (is_body_free)
            (at_space_y y_front)
            (at_space_z z_up)
            (increase (control_the_transition) 1)
            (increase (all_action_times) 1)
        ))
    )
)

;;在up状态下才能执行从前摆到竖立的状态，防止了下蹲的动作衔接直立动作
(:durative-action frontToMid
    :parameters (?rate - rate)
    :duration (= ?duration 0.5)
    :condition (and 
        (at start (and
            (at_space_z z_up)
            (at_space_y y_front)
            (is_body_free)
            (< (all_action_times) 1)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_z z_up))
            (not (at_space_y y_front))
        ))
        (at end (and 
            (increase (dance-time) 0.5) ;时间增加
            (is_body_free)
            (at_space_z z_up)
            (at_space_y y_mid)
            (increase (control_the_transition) 1)
            (increase (all_action_times) 1)
        ))
    )
)
;;由下蹲到直立的状态
(:durative-action downToUp
    :parameters (?rate - rate)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (at_space_z z_down)
            (is_body_free)
            (< (all_action_times) 1)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_z z_down))
        ))
        (at end (and 
            (increase (dance-time) 1) ;时间增加
            (is_body_free)
            (at_space_z z_up)
            (increase (control_the_transition) 1)
            (increase (all_action_times) 1)
        ))
    )
)
;;由直立到下蹲的状态
(:durative-action UpToDown
    :parameters (?rate - rate)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (at_space_z z_up)
            (is_body_free)
            (< (all_action_times) 1)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_z z_up)))
        )
        (at end (and 
            (increase (dance-time) 1) ;时间增加
            (is_body_free)
            (at_space_z z_down)
            (increase (control_the_transition) 1)
            (increase (all_action_times) 1)

        ))
    )
)
;;将胸前的手稳定的移动为立正姿态
(:durative-action handToAttention
    :parameters (?rate - rate)
    :duration (= ?duration 0.4)
    :condition (and 
        (at start (and
            (at_hand prethoracic)
            (is_body_free)
            (< (all_action_times) 1)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_hand prethoracic))
            ))
        (at end (and 
            (increase (dance-time) 0.4) ;时间增加
            (is_body_free)
            (at_hand others)
            (increase (control_the_transition) 2)
            (increase (all_action_times) 1)
        ))
    )
)
(:durative-action takeTheLeft
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.883 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s1)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.883 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s1)
            (best-rate s1 ?rate)
            (increase (action-times s1) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action runningMan
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.992 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s2)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.992 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s2)
            (best-rate s2 ?rate)
            (increase (action-times s2) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftPunch
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s3)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.797 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s3)
            (best-rate s3 ?rate)
            (increase (action-times s3) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action parallelHandsAkimboErect
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s4)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.805 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s4)
            (best-rate s4 ?rate)
            (increase (action-times s4) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action beatUpAndDown
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand prethoracic)

            (waiting s5)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand others))

        ))
        (at end (and 
            (increase (dance-time) (* 0.797 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s5)
            (best-rate s5 ?rate)
            (increase (action-times s5) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand prethoracic)

        ))
    )
)

(:durative-action enlargeBosmHoodwink
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.906 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s6)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.906 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s6)
            (best-rate s6 ?rate)
            (increase (action-times s6) 1)
            (at_space_y y_mid)
(at_space_z z_down)
(at_hand others)

        ))
    )
)

(:durative-action fastAdvance
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.516 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s7)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.516 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s7)
            (best-rate s7 ?rate)
            (increase (action-times s7) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action twistWaist
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.531 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_z z_up)
(at_hand others)

            (waiting s8)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.531 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s8)
            (best-rate s8 ?rate)
            (increase (action-times s8) 1)
            (at_hand others)

        ))
    )
)

(:durative-action leftRightRhythm
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s9)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s9)
            (best-rate s9 ?rate)
            (increase (action-times s9) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action akimboDown
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s10)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.797 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s10)
            (best-rate s10 ?rate)
            (increase (action-times s10) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action shockHandsToChest
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.312 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s11)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.312 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s11)
            (best-rate s11 ?rate)
            (increase (action-times s11) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action sidestepLeft
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s12)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.805 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s12)
            (best-rate s12 ?rate)
            (increase (action-times s12) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action handToAttention
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.406 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_z z_up)
(at_hand others)

            (waiting s13)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.406 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s13)
            (best-rate s13 ?rate)
            (increase (action-times s13) 1)
            (at_hand others)

        ))
    )
)

(:durative-action sideMovement
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.75 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s14)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.75 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s14)
            (best-rate s14 ?rate)
            (increase (action-times s14) 1)
            (at_space_y y_front)
(at_space_z z_up)
(increase (at_floor_space) 11.25)
(at_hand others)

        ))
    )
)

(:durative-action leftRightOut
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.953 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s15)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 2.953 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s15)
            (best-rate s15 ?rate)
            (increase (action-times s15) 1)
            (at_space_y y_mid)
(at_space_z z_down)
(at_hand others)

        ))
    )
)

(:durative-action salute
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.195 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s16)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.195 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s16)
            (best-rate s16 ?rate)
            (increase (action-times s16) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action hitChest
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.906 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s17)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.906 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s17)
            (best-rate s17 ?rate)
            (increase (action-times s17) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action parallelHands
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_z z_up)
(at_hand others)

            (waiting s18)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s18)
            (best-rate s18 ?rate)
            (increase (action-times s18) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action splitLeap
    :parameters (?rate - rate)
    :duration (= ?duration (* 3.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s19)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 3.602 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s19)
            (best-rate s19 ?rate)
            (increase (action-times s19) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftSideKick
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.922 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s20)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.922 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s20)
            (best-rate s20 ?rate)
            (increase (action-times s20) 1)
            (at_space_y y_front)
(at_space_z z_up)
(increase (at_floor_space) 3.6)
(at_hand others)

        ))
    )
)

(:durative-action openHeartLeft
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.703 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s21)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.703 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s21)
            (best-rate s21 ?rate)
            (increase (action-times s21) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action crossFingers
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.781 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s22)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.781 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s22)
            (best-rate s22 ?rate)
            (increase (action-times s22) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftFuels
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s23)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s23)
            (best-rate s23 ?rate)
            (increase (action-times s23) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(increase (at_floor_space) 9)
(at_hand others)

        ))
    )
)

(:durative-action armsUpward
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s24)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s24)
            (best-rate s24 ?rate)
            (increase (action-times s24) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftHandWave
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s25)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 2.602 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s25)
            (best-rate s25 ?rate)
            (increase (action-times s25) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action akimbo
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.609 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s26)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.609 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s26)
            (best-rate s26 ?rate)
            (increase (action-times s26) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action handsWaveUp
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s27)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s27)
            (best-rate s27 ?rate)
            (increase (action-times s27) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action motionHands
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.695 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s28)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.695 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s28)
            (best-rate s28 ?rate)
            (increase (action-times s28) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action sitDown
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s29)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s29)
            (best-rate s29 ?rate)
            (increase (action-times s29) 1)
            (at_space_y y_mid)
(at_space_z z_down)
(at_hand others)

        ))
    )
)

(:durative-action rightHandFan
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s30)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.203 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s30)
            (best-rate s30 ?rate)
            (increase (action-times s30) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftProtest
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.703 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s31)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.703 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s31)
            (best-rate s31 ?rate)
            (increase (action-times s31) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftHandsObliqueParallel
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s32)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand others))

        ))
        (at end (and 
            (increase (dance-time) (* 0.805 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s32)
            (best-rate s32 ?rate)
            (increase (action-times s32) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand prethoracic)

        ))
    )
)

(:durative-action shockHands
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s33)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s33)
            (best-rate s33 ?rate)
            (increase (action-times s33) 1)
            (at_space_y y_front)
(at_space_z z_down)
(at_hand others)

        ))
    )
)

(:durative-action rightLean
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.508 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s34)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.508 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s34)
            (best-rate s34 ?rate)
            (increase (action-times s34) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action leftTurn
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.695 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s35)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.695 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s35)
            (best-rate s35 ?rate)
            (increase (action-times s35) 1)
            (at_space_y y_front)
(at_space_z z_up)
(increase (at_floor_space) 5.6)
(at_hand others)

        ))
    )
)

(:durative-action rightHandUp
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s36)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.203 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s36)
            (best-rate s36 ?rate)
            (increase (action-times s36) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action finesseSwing
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s37)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.602 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s37)
            (best-rate s37 ?rate)
            (increase (action-times s37) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action mergeHand
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.703 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

            (waiting s38)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_front))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.703 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s38)
            (best-rate s38 ?rate)
            (increase (action-times s38) 1)
            (at_space_y y_front)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action akimboRaise
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.883 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s39)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 0.883 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s39)
            (best-rate s39 ?rate)
            (increase (action-times s39) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action handsWaveDown
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s40)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s40)
            (best-rate s40 ?rate)
            (increase (action-times s40) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action abandon
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s41)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s41)
            (best-rate s41 ?rate)
            (increase (action-times s41) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action upwardPunches
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s42)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.602 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s42)
            (best-rate s42 ?rate)
            (increase (action-times s42) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)

(:durative-action hands_90
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            ; 前置约束， 效果中的rank不会出现在这之中
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

            (waiting s43)
            (is_body_free)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free))
            (not (at_space_y y_mid))
(not (at_space_z z_up))
(not (at_hand prethoracic))

        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate))) ;时间增加
            (is_body_free)
            (finished s43)
            (best-rate s43 ?rate)
            (increase (action-times s43) 1)
            (at_space_y y_mid)
(at_space_z z_up)
(at_hand others)

        ))
    )
)


)
