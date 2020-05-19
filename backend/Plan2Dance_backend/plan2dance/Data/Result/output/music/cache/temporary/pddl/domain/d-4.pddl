(define (domain d-robot-4)
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
(:constants
    s1	s2	s3	s4	s5	 - state
s6	s7	s8	s9	s10	 - state
s11	s12	s13	s14	s15	 - state
s16	s17	s18	s19	s20	 - state
s21	s22	s23	s24	s25	 - state
s26	s27	s28	s29	s30	 - state
s31	s32	s33	s34	s35	 - state
s36	s37	s38	s39	s40	 - state
s41	s42	s43	s44	s45	 - state
s46	s47	s48	s49	s50	 - state
s51	s52	s53	s54	s55	 - state
s56	s57	s58	s59	s60	 - state
s61	s62	s63	s64	s65	 - state
s66	s67	s68	s69	s70	 - state
s71	s72	s73	s74	s75	 - state
s76	s77	s78	s79	s80	 - state
s81	s82	s83	s84	s85	 - state

    forward centre backward - space-y
    stand half-squat squat - space-z
    chest others - space-hand
    hand-left hand-right leg-left leg-right - body-parts
    high-frequency intermediate-frequency low-frequency dance-frequency common-frequency - frequency
)
(:predicates ;todo: define predicates here
    (is_body_free ?bd - body-parts)  ; Represents physical resource constraints
    (waiting ?s - state)  ; Candidate Action
    (finished ?s - state) ; Completion of an action
    (at-body-space-y ?sy - space-y) ; Lean forward and back
    (at-body-space-z ?sz - space-z) ; Stand or squat
    (at-body-space-hand ?sh - space-hand) ; Arm position :Because the arm of the experimental robot is placed in front of the chest and there is a volume collision
    (action-frequency ?s - state ?f - frequency)
    (best-rate ?s - state ?rate - rate) ;最佳速率
    
    (at-beat ?b - beat) ; 定义节拍出现点
    (beat-satisfy ?b - beat ?s - state) ; 满足节拍条件
    
)

(:functions ;todo: define numeric functions here
    (dance-time)  ; Dance Time
    (execute-times ?s - state)  ; Number of Action performed
    (action-rate ?rate - rate)  ; Action Using Rate
    (high-frequency-times)  ; Number of high frequency actions performed
    (inter-frequency-times)  ; Number of intermediate frequency actions performed
    
    (beat-satisfy-times)
    
)
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


(:durative-action rotatingrighthand_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.781)
    :condition (and 
        (at start (and 
            (waiting s1)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.781)
            (increase (execute-times s1) 1)
            (finished s1)
            (action-frequency s1 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action rotatingrighthand
    :parameters ()
    :duration (= ?duration 1.781)
    :condition (and 
        (at start (and 
            (waiting s1)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.781)
            (increase (execute-times s1) 1)
            (finished s1)
            (action-frequency s1 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action drumroll_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.828)
    :condition (and 
        (at start (and 
            (waiting s2)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.828)
            (increase (execute-times s2) 1)
            (finished s2)
            (action-frequency s2 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action drumroll
    :parameters ()
    :duration (= ?duration 1.828)
    :condition (and 
        (at start (and 
            (waiting s2)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.828)
            (increase (execute-times s2) 1)
            (finished s2)
            (action-frequency s2 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action handupanddown_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 3.0)
    :condition (and 
        (at start (and 
            (waiting s3)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 3.0)
            (increase (execute-times s3) 1)
            (finished s3)
            (action-frequency s3 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handupanddown
    :parameters ()
    :duration (= ?duration 3.0)
    :condition (and 
        (at start (and 
            (waiting s3)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 3.0)
            (increase (execute-times s3) 1)
            (finished s3)
            (action-frequency s3 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action taketheleft_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.883)
    :condition (and 
        (at start (and 
            (waiting s4)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.883)
            (increase (execute-times s4) 1)
            (finished s4)
            (action-frequency s4 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action taketheleft
    :parameters ()
    :duration (= ?duration 0.883)
    :condition (and 
        (at start (and 
            (waiting s4)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.883)
            (increase (execute-times s4) 1)
            (finished s4)
            (action-frequency s4 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action raisehandanddropdown_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.703)
    :condition (and 
        (at start (and 
            (waiting s5)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.703)
            (increase (execute-times s5) 1)
            (finished s5)
            (action-frequency s5 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action raisehandanddropdown
    :parameters ()
    :duration (= ?duration 2.703)
    :condition (and 
        (at start (and 
            (waiting s5)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.703)
            (increase (execute-times s5) 1)
            (finished s5)
            (action-frequency s5 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action fastadvance_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.516)
    :condition (and 
        (at start (and 
            (waiting s6)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.516)
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action fastadvance
    :parameters ()
    :duration (= ?duration 0.516)
    :condition (and 
        (at start (and 
            (waiting s6)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.516)
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action sidestepleft_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s7)
            (at-beat ?beat)
            
            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            
            
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.805)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 intermediate-frequency)
			(increase (inter-frequency-times) 1)

            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action sidestepleft
    :parameters ()
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s7)
            
            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            
            
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.805)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 intermediate-frequency)
			(increase (inter-frequency-times) 1)

            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action shoulderrhythm_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.789)
    :condition (and 
        (at start (and 
            (waiting s8)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.789)
            (increase (execute-times s8) 1)
            (finished s8)
            (action-frequency s8 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action shoulderrhythm
    :parameters ()
    :duration (= ?duration 0.789)
    :condition (and 
        (at start (and 
            (waiting s8)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.789)
            (increase (execute-times s8) 1)
            (finished s8)
            (action-frequency s8 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftfuels_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s9)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate)))
            (increase (execute-times s9) 1)
            (best-rate s9 ?rate)
            (finished s9)
            (action-frequency s9 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftfuels
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s9)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate)))
            (increase (execute-times s9) 1)
            (best-rate s9 ?rate)
            (finished s9)
            (action-frequency s9 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action lefthandwave_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 2.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s10)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 2.602 (action-rate ?rate)))
            (increase (execute-times s10) 1)
            (best-rate s10 ?rate)
            (finished s10)
            (action-frequency s10 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action lefthandwave
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s10)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 2.602 (action-rate ?rate)))
            (increase (execute-times s10) 1)
            (best-rate s10 ?rate)
            (finished s10)
            (action-frequency s10 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action openheartleft_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.703)
    :condition (and 
        (at start (and 
            (waiting s11)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.703)
            (increase (execute-times s11) 1)
            (finished s11)
            (action-frequency s11 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action openheartleft
    :parameters ()
    :duration (= ?duration 0.703)
    :condition (and 
        (at start (and 
            (waiting s11)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.703)
            (increase (execute-times s11) 1)
            (finished s11)
            (action-frequency s11 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action crossfingers_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.781)
    :condition (and 
        (at start (and 
            (waiting s12)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.781)
            (increase (execute-times s12) 1)
            (finished s12)
            (action-frequency s12 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action crossfingers
    :parameters ()
    :duration (= ?duration 0.781)
    :condition (and 
        (at start (and 
            (waiting s12)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.781)
            (increase (execute-times s12) 1)
            (finished s12)
            (action-frequency s12 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action handfly_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.75)
    :condition (and 
        (at start (and 
            (waiting s13)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.75)
            (increase (execute-times s13) 1)
            (finished s13)
            (action-frequency s13 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handfly
    :parameters ()
    :duration (= ?duration 1.75)
    :condition (and 
        (at start (and 
            (waiting s13)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.75)
            (increase (execute-times s13) 1)
            (finished s13)
            (action-frequency s13 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action sidemovement_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.391)
    :condition (and 
        (at start (and 
            (waiting s14)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.391)
            (increase (execute-times s14) 1)
            (finished s14)
            (action-frequency s14 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action sidemovement
    :parameters ()
    :duration (= ?duration 1.391)
    :condition (and 
        (at start (and 
            (waiting s14)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.391)
            (increase (execute-times s14) 1)
            (finished s14)
            (action-frequency s14 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action spreadwings_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.406)
    :condition (and 
        (at start (and 
            (waiting s15)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.406)
            (increase (execute-times s15) 1)
            (finished s15)
            (action-frequency s15 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action spreadwings
    :parameters ()
    :duration (= ?duration 1.406)
    :condition (and 
        (at start (and 
            (waiting s15)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.406)
            (increase (execute-times s15) 1)
            (finished s15)
            (action-frequency s15 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action liftthechest_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.797)
    :condition (and 
        (at start (and 
            (waiting s16)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.797)
            (increase (execute-times s16) 1)
            (finished s16)
            (action-frequency s16 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action liftthechest
    :parameters ()
    :duration (= ?duration 1.797)
    :condition (and 
        (at start (and 
            (waiting s16)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.797)
            (increase (execute-times s16) 1)
            (finished s16)
            (action-frequency s16 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action twistwaist_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.531)
    :condition (and 
        (at start (and 
            (waiting s17)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.531)
            (increase (execute-times s17) 1)
            (finished s17)
            (action-frequency s17 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action twistwaist
    :parameters ()
    :duration (= ?duration 0.531)
    :condition (and 
        (at start (and 
            (waiting s17)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.531)
            (increase (execute-times s17) 1)
            (finished s17)
            (action-frequency s17 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action handswavedown_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s18)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s18) 1)
            (best-rate s18 ?rate)
            (finished s18)
            (action-frequency s18 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handswavedown
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s18)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s18) 1)
            (best-rate s18 ?rate)
            (finished s18)
            (action-frequency s18 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action abandon_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s19)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate)))
            (increase (execute-times s19) 1)
            (best-rate s19 ?rate)
            (finished s19)
            (action-frequency s19 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action abandon
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s19)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate)))
            (increase (execute-times s19) 1)
            (best-rate s19 ?rate)
            (finished s19)
            (action-frequency s19 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action lefthandsobliqueparallel_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s20)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.805)
            (increase (execute-times s20) 1)
            (finished s20)
            (action-frequency s20 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action lefthandsobliqueparallel
    :parameters ()
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s20)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.805)
            (increase (execute-times s20) 1)
            (finished s20)
            (action-frequency s20 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action handappearance_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.969)
    :condition (and 
        (at start (and 
            (waiting s21)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 0.969)
            (increase (execute-times s21) 1)
            (finished s21)
            (action-frequency s21 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handappearance
    :parameters ()
    :duration (= ?duration 0.969)
    :condition (and 
        (at start (and 
            (waiting s21)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 0.969)
            (increase (execute-times s21) 1)
            (finished s21)
            (action-frequency s21 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action shakehands_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 0.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s22)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 0.805 (action-rate ?rate)))
            (increase (execute-times s22) 1)
            (best-rate s22 ?rate)
            (finished s22)
            (action-frequency s22 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action shakehands
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s22)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 0.805 (action-rate ?rate)))
            (increase (execute-times s22) 1)
            (best-rate s22 ?rate)
            (finished s22)
            (action-frequency s22 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action runningman_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.992)
    :condition (and 
        (at start (and 
            (waiting s23)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.992)
            (increase (execute-times s23) 1)
            (finished s23)
            (action-frequency s23 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action runningman
    :parameters ()
    :duration (= ?duration 1.992)
    :condition (and 
        (at start (and 
            (waiting s23)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.992)
            (increase (execute-times s23) 1)
            (finished s23)
            (action-frequency s23 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftprotest_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 0.703 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s24)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 0.703 (action-rate ?rate)))
            (increase (execute-times s24) 1)
            (best-rate s24 ?rate)
            (finished s24)
            (action-frequency s24 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftprotest
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.703 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s24)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 0.703 (action-rate ?rate)))
            (increase (execute-times s24) 1)
            (best-rate s24 ?rate)
            (finished s24)
            (action-frequency s24 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action righthandfan_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s25)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.203 (action-rate ?rate)))
            (increase (execute-times s25) 1)
            (best-rate s25 ?rate)
            (finished s25)
            (action-frequency s25 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action righthandfan
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s25)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 1.203 (action-rate ?rate)))
            (increase (execute-times s25) 1)
            (best-rate s25 ?rate)
            (finished s25)
            (action-frequency s25 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action akimbo_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 0.609 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s26)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 0.609 (action-rate ?rate)))
            (increase (execute-times s26) 1)
            (best-rate s26 ?rate)
            (finished s26)
            (action-frequency s26 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action akimbo
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.609 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s26)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 0.609 (action-rate ?rate)))
            (increase (execute-times s26) 1)
            (best-rate s26 ?rate)
            (finished s26)
            (action-frequency s26 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action rightswing_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.602)
    :condition (and 
        (at start (and 
            (waiting s27)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y backward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.602)
            (increase (execute-times s27) 1)
            (finished s27)
            (action-frequency s27 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action rightswing
    :parameters ()
    :duration (= ?duration 1.602)
    :condition (and 
        (at start (and 
            (waiting s27)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y backward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.602)
            (increase (execute-times s27) 1)
            (finished s27)
            (action-frequency s27 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action enlargebosmhoodwink_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.906)
    :condition (and 
        (at start (and 
            (waiting s28)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.906)
            (increase (execute-times s28) 1)
            (finished s28)
            (action-frequency s28 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action enlargebosmhoodwink
    :parameters ()
    :duration (= ?duration 0.906)
    :condition (and 
        (at start (and 
            (waiting s28)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.906)
            (increase (execute-times s28) 1)
            (finished s28)
            (action-frequency s28 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftrightrhythm_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s29)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s29) 1)
            (best-rate s29 ?rate)
            (finished s29)
            (action-frequency s29 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftrightrhythm
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s29)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s29) 1)
            (best-rate s29 ?rate)
            (finished s29)
            (action-frequency s29 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action rightlean_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.508 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s30)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.508 (action-rate ?rate)))
            (increase (execute-times s30) 1)
            (best-rate s30 ?rate)
            (finished s30)
            (action-frequency s30 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action rightlean
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.508 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s30)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 1.508 (action-rate ?rate)))
            (increase (execute-times s30) 1)
            (best-rate s30 ?rate)
            (finished s30)
            (action-frequency s30 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action upwardpunches_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.188)
    :condition (and 
        (at start (and 
            (waiting s31)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.188)
            (increase (execute-times s31) 1)
            (finished s31)
            (action-frequency s31 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action upwardpunches
    :parameters ()
    :duration (= ?duration 2.188)
    :condition (and 
        (at start (and 
            (waiting s31)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.188)
            (increase (execute-times s31) 1)
            (finished s31)
            (action-frequency s31 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action finesseswing_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s32)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.602 (action-rate ?rate)))
            (increase (execute-times s32) 1)
            (best-rate s32 ?rate)
            (finished s32)
            (action-frequency s32 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action finesseswing
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s32)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.602 (action-rate ?rate)))
            (increase (execute-times s32) 1)
            (best-rate s32 ?rate)
            (finished s32)
            (action-frequency s32 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action parallelhandsakimboerect_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s33)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.805 (action-rate ?rate)))
            (increase (execute-times s33) 1)
            (best-rate s33 ?rate)
            (finished s33)
            (action-frequency s33 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action parallelhandsakimboerect
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.805 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s33)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.805 (action-rate ?rate)))
            (increase (execute-times s33) 1)
            (best-rate s33 ?rate)
            (finished s33)
            (action-frequency s33 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action akimbodown_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s34)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.797 (action-rate ?rate)))
            (increase (execute-times s34) 1)
            (best-rate s34 ?rate)
            (finished s34)
            (action-frequency s34 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action akimbodown
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s34)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.797 (action-rate ?rate)))
            (increase (execute-times s34) 1)
            (best-rate s34 ?rate)
            (finished s34)
            (action-frequency s34 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action handswaveup_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s35)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s35) 1)
            (best-rate s35 ?rate)
            (finished s35)
            (action-frequency s35 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handswaveup
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s35)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s35) 1)
            (best-rate s35 ?rate)
            (finished s35)
            (action-frequency s35 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftrightout_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 3.93)
    :condition (and 
        (at start (and 
            (waiting s36)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 3.93)
            (increase (execute-times s36) 1)
            (finished s36)
            (action-frequency s36 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftrightout
    :parameters ()
    :duration (= ?duration 3.93)
    :condition (and 
        (at start (and 
            (waiting s36)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 3.93)
            (increase (execute-times s36) 1)
            (finished s36)
            (action-frequency s36 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action shockhandstochest_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.312)
    :condition (and 
        (at start (and 
            (waiting s37)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.312)
            (increase (execute-times s37) 1)
            (finished s37)
            (action-frequency s37 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action shockhandstochest
    :parameters ()
    :duration (= ?duration 1.312)
    :condition (and 
        (at start (and 
            (waiting s37)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.312)
            (increase (execute-times s37) 1)
            (finished s37)
            (action-frequency s37 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action leftpunch_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s38)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 0.797 (action-rate ?rate)))
            (increase (execute-times s38) 1)
            (best-rate s38 ?rate)
            (finished s38)
            (action-frequency s38 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftpunch
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s38)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 0.797 (action-rate ?rate)))
            (increase (execute-times s38) 1)
            (best-rate s38 ?rate)
            (finished s38)
            (action-frequency s38 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action heavypendulum_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s39)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 2.0)
            (increase (execute-times s39) 1)
            (finished s39)
            (action-frequency s39 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action heavypendulum
    :parameters ()
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s39)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 2.0)
            (increase (execute-times s39) 1)
            (finished s39)
            (action-frequency s39 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action shockhands_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.0)
    :condition (and 
        (at start (and 
            (waiting s40)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.0)
            (increase (execute-times s40) 1)
            (finished s40)
            (action-frequency s40 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action shockhands
    :parameters ()
    :duration (= ?duration 1.0)
    :condition (and 
        (at start (and 
            (waiting s40)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.0)
            (increase (execute-times s40) 1)
            (finished s40)
            (action-frequency s40 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action righthandup_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s41)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y backward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.203 (action-rate ?rate)))
            (increase (execute-times s41) 1)
            (best-rate s41 ?rate)
            (finished s41)
            (action-frequency s41 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action righthandup
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s41)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y backward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 1.203 (action-rate ?rate)))
            (increase (execute-times s41) 1)
            (best-rate s41 ?rate)
            (finished s41)
            (action-frequency s41 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action hitchest_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.906)
    :condition (and 
        (at start (and 
            (waiting s42)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.906)
            (increase (execute-times s42) 1)
            (finished s42)
            (action-frequency s42 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action hitchest
    :parameters ()
    :duration (= ?duration 0.906)
    :condition (and 
        (at start (and 
            (waiting s42)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.906)
            (increase (execute-times s42) 1)
            (finished s42)
            (action-frequency s42 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action armsupward_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s43)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s43) 1)
            (best-rate s43 ?rate)
            (finished s43)
            (action-frequency s43 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action armsupward
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s43)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 2.0 (action-rate ?rate)))
            (increase (execute-times s43) 1)
            (best-rate s43 ?rate)
            (finished s43)
            (action-frequency s43 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action parallelhands_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s44)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate)))
            (increase (execute-times s44) 1)
            (best-rate s44 ?rate)
            (finished s44)
            (action-frequency s44 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action parallelhands
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s44)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.0 (action-rate ?rate)))
            (increase (execute-times s44) 1)
            (best-rate s44 ?rate)
            (finished s44)
            (action-frequency s44 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftturn_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.664)
    :condition (and 
        (at start (and 
            (waiting s45)
            (at-beat ?beat)
            
            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            
            
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.664)
            (increase (execute-times s45) 1)
            (finished s45)
            (action-frequency s45 intermediate-frequency)
			(increase (inter-frequency-times) 1)

            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftturn
    :parameters ()
    :duration (= ?duration 1.664)
    :condition (and 
        (at start (and 
            (waiting s45)
            
            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            
            
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.664)
            (increase (execute-times s45) 1)
            (finished s45)
            (action-frequency s45 intermediate-frequency)
			(increase (inter-frequency-times) 1)

            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action motionhands_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.695)
    :condition (and 
        (at start (and 
            (waiting s46)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.695)
            (increase (execute-times s46) 1)
            (finished s46)
            (action-frequency s46 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action motionhands
    :parameters ()
    :duration (= ?duration 0.695)
    :condition (and 
        (at start (and 
            (waiting s46)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.695)
            (increase (execute-times s46) 1)
            (finished s46)
            (action-frequency s46 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action beatupanddown_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s47)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 0.797 (action-rate ?rate)))
            (increase (execute-times s47) 1)
            (best-rate s47 ?rate)
            (finished s47)
            (action-frequency s47 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action beatupanddown
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s47)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 0.797 (action-rate ?rate)))
            (increase (execute-times s47) 1)
            (best-rate s47 ?rate)
            (finished s47)
            (action-frequency s47 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action elbowturn_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.133)
    :condition (and 
        (at start (and 
            (waiting s48)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.133)
            (increase (execute-times s48) 1)
            (finished s48)
            (action-frequency s48 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action elbowturn
    :parameters ()
    :duration (= ?duration 2.133)
    :condition (and 
        (at start (and 
            (waiting s48)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.133)
            (increase (execute-times s48) 1)
            (finished s48)
            (action-frequency s48 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action mergehand_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.703)
    :condition (and 
        (at start (and 
            (waiting s49)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 0.703)
            (increase (execute-times s49) 1)
            (finished s49)
            (action-frequency s49 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action mergehand
    :parameters ()
    :duration (= ?duration 0.703)
    :condition (and 
        (at start (and 
            (waiting s49)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 0.703)
            (increase (execute-times s49) 1)
            (finished s49)
            (action-frequency s49 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action akimboraise_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 0.883 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s50)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 0.883 (action-rate ?rate)))
            (increase (execute-times s50) 1)
            (best-rate s50 ?rate)
            (finished s50)
            (action-frequency s50 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action akimboraise
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.883 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s50)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 0.883 (action-rate ?rate)))
            (increase (execute-times s50) 1)
            (best-rate s50 ?rate)
            (finished s50)
            (action-frequency s50 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action splitleap_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 3.602)
    :condition (and 
        (at start (and 
            (waiting s51)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 3.602)
            (increase (execute-times s51) 1)
            (finished s51)
            (action-frequency s51 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action splitleap
    :parameters ()
    :duration (= ?duration 3.602)
    :condition (and 
        (at start (and 
            (waiting s51)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 3.602)
            (increase (execute-times s51) 1)
            (finished s51)
            (action-frequency s51 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action scratchinghead_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s52)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.797 (action-rate ?rate)))
            (increase (execute-times s52) 1)
            (best-rate s52 ?rate)
            (finished s52)
            (action-frequency s52 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action scratchinghead
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s52)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.797 (action-rate ?rate)))
            (increase (execute-times s52) 1)
            (best-rate s52 ?rate)
            (finished s52)
            (action-frequency s52 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftsidekick_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.922)
    :condition (and 
        (at start (and 
            (waiting s53)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.922)
            (increase (execute-times s53) 1)
            (finished s53)
            (action-frequency s53 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftsidekick
    :parameters ()
    :duration (= ?duration 0.922)
    :condition (and 
        (at start (and 
            (waiting s53)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.922)
            (increase (execute-times s53) 1)
            (finished s53)
            (action-frequency s53 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftrightwave_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.844)
    :condition (and 
        (at start (and 
            (waiting s54)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.844)
            (increase (execute-times s54) 1)
            (finished s54)
            (action-frequency s54 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftrightwave
    :parameters ()
    :duration (= ?duration 1.844)
    :condition (and 
        (at start (and 
            (waiting s54)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.844)
            (increase (execute-times s54) 1)
            (finished s54)
            (action-frequency s54 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action soldiersalute_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.195)
    :condition (and 
        (at start (and 
            (waiting s55)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.195)
            (increase (execute-times s55) 1)
            (finished s55)
            (action-frequency s55 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action soldiersalute
    :parameters ()
    :duration (= ?duration 1.195)
    :condition (and 
        (at start (and 
            (waiting s55)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.195)
            (increase (execute-times s55) 1)
            (finished s55)
            (action-frequency s55 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action shakeelbow_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 3.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s56)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 3.0 (action-rate ?rate)))
            (increase (execute-times s56) 1)
            (best-rate s56 ?rate)
            (finished s56)
            (action-frequency s56 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action shakeelbow
    :parameters (?rate - rate)
    :duration (= ?duration (* 3.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s56)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 3.0 (action-rate ?rate)))
            (increase (execute-times s56) 1)
            (best-rate s56 ?rate)
            (finished s56)
            (action-frequency s56 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action squat_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.602)
    :condition (and 
        (at start (and 
            (waiting s57)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.602)
            (increase (execute-times s57) 1)
            (finished s57)
            (action-frequency s57 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action squat
    :parameters ()
    :duration (= ?duration 1.602)
    :condition (and 
        (at start (and 
            (waiting s57)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.602)
            (increase (execute-times s57) 1)
            (finished s57)
            (action-frequency s57 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action swinghandsputup_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.172)
    :condition (and 
        (at start (and 
            (waiting s58)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.172)
            (increase (execute-times s58) 1)
            (finished s58)
            (action-frequency s58 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action swinghandsputup
    :parameters ()
    :duration (= ?duration 2.172)
    :condition (and 
        (at start (and 
            (waiting s58)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.172)
            (increase (execute-times s58) 1)
            (finished s58)
            (action-frequency s58 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action putuphandsdown_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.992)
    :condition (and 
        (at start (and 
            (waiting s59)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.992)
            (increase (execute-times s59) 1)
            (finished s59)
            (action-frequency s59 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action putuphandsdown
    :parameters ()
    :duration (= ?duration 0.992)
    :condition (and 
        (at start (and 
            (waiting s59)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.992)
            (increase (execute-times s59) 1)
            (finished s59)
            (action-frequency s59 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action swingshake_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s60)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.875 (action-rate ?rate)))
            (increase (execute-times s60) 1)
            (best-rate s60 ?rate)
            (finished s60)
            (action-frequency s60 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action swingshake
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s60)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.875 (action-rate ?rate)))
            (increase (execute-times s60) 1)
            (best-rate s60 ?rate)
            (finished s60)
            (action-frequency s60 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action power_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s61)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 2.945)
            (increase (execute-times s61) 1)
            (finished s61)
            (action-frequency s61 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action power
    :parameters ()
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s61)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y forward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 2.945)
            (increase (execute-times s61) 1)
            (finished s61)
            (action-frequency s61 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action lefthandbend_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s62)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s62) 1)
            (finished s62)
            (action-frequency s62 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action lefthandbend
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s62)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s62) 1)
            (finished s62)
            (action-frequency s62 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action righthook_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.117 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s63)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.117 (action-rate ?rate)))
            (increase (execute-times s63) 1)
            (best-rate s63 ?rate)
            (finished s63)
            (action-frequency s63 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action righthook
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.117 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s63)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.117 (action-rate ?rate)))
            (increase (execute-times s63) 1)
            (best-rate s63 ?rate)
            (finished s63)
            (action-frequency s63 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action roar_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.133)
    :condition (and 
        (at start (and 
            (waiting s64)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.133)
            (increase (execute-times s64) 1)
            (finished s64)
            (action-frequency s64 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action roar
    :parameters ()
    :duration (= ?duration 2.133)
    :condition (and 
        (at start (and 
            (waiting s64)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.133)
            (increase (execute-times s64) 1)
            (finished s64)
            (action-frequency s64 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action swinghandsfootside_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s65)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.875 (action-rate ?rate)))
            (increase (execute-times s65) 1)
            (best-rate s65 ?rate)
            (finished s65)
            (action-frequency s65 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action swinghandsfootside
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s65)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) (* 1.875 (action-rate ?rate)))
            (increase (execute-times s65) 1)
            (best-rate s65 ?rate)
            (finished s65)
            (action-frequency s65 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action allforme_beat
    :parameters (?rate - rate ?beat - beat)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s66)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) (* 1.875 (action-rate ?rate)))
            (increase (execute-times s66) 1)
            (best-rate s66 ?rate)
            (finished s66)
            (action-frequency s66 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action allforme
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s66)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) (* 1.875 (action-rate ?rate)))
            (increase (execute-times s66) 1)
            (best-rate s66 ?rate)
            (finished s66)
            (action-frequency s66 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action handsbendinward_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s67)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s67) 1)
            (finished s67)
            (action-frequency s67 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handsbendinward
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s67)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s67) 1)
            (finished s67)
            (action-frequency s67 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action rightblock_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.0)
    :condition (and 
        (at start (and 
            (waiting s68)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.0)
            (increase (execute-times s68) 1)
            (finished s68)
            (action-frequency s68 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action rightblock
    :parameters ()
    :duration (= ?duration 1.0)
    :condition (and 
        (at start (and 
            (waiting s68)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.0)
            (increase (execute-times s68) 1)
            (finished s68)
            (action-frequency s68 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action handscircle_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s69)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s69) 1)
            (finished s69)
            (action-frequency s69 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handscircle
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s69)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s69) 1)
            (finished s69)
            (action-frequency s69 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action handheadfoot_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s70)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s70) 1)
            (finished s70)
            (action-frequency s70 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handheadfoot
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s70)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s70) 1)
            (finished s70)
            (action-frequency s70 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action runaround_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.312)
    :condition (and 
        (at start (and 
            (waiting s71)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.312)
            (increase (execute-times s71) 1)
            (finished s71)
            (action-frequency s71 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action runaround
    :parameters ()
    :duration (= ?duration 2.312)
    :condition (and 
        (at start (and 
            (waiting s71)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.312)
            (increase (execute-times s71) 1)
            (finished s71)
            (action-frequency s71 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action verticalarm_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.602)
    :condition (and 
        (at start (and 
            (waiting s72)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.602)
            (increase (execute-times s72) 1)
            (finished s72)
            (action-frequency s72 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action verticalarm
    :parameters ()
    :duration (= ?duration 2.602)
    :condition (and 
        (at start (and 
            (waiting s72)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.602)
            (increase (execute-times s72) 1)
            (finished s72)
            (action-frequency s72 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action raisehandstakehear_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s73)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 2.953)
            (increase (execute-times s73) 1)
            (finished s73)
            (action-frequency s73 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action raisehandstakehear
    :parameters ()
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s73)
            (is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            
            
            (not (at-body-space-y centre))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 2.953)
            (increase (execute-times s73) 1)
            (finished s73)
            (action-frequency s73 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action dancingyouth_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s74)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.945)
            (increase (execute-times s74) 1)
            (finished s74)
            (action-frequency s74 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action dancingyouth
    :parameters ()
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s74)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.945)
            (increase (execute-times s74) 1)
            (finished s74)
            (action-frequency s74 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action liftingarm_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s75)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s75) 1)
            (finished s75)
            (action-frequency s75 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action liftingarm
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s75)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s75) 1)
            (finished s75)
            (action-frequency s75 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action kettle_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.312)
    :condition (and 
        (at start (and 
            (waiting s76)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.312)
            (increase (execute-times s76) 1)
            (finished s76)
            (action-frequency s76 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action kettle
    :parameters ()
    :duration (= ?duration 1.312)
    :condition (and 
        (at start (and 
            (waiting s76)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.312)
            (increase (execute-times s76) 1)
            (finished s76)
            (action-frequency s76 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftattack_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.438)
    :condition (and 
        (at start (and 
            (waiting s77)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.438)
            (increase (execute-times s77) 1)
            (finished s77)
            (action-frequency s77 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action leftattack
    :parameters ()
    :duration (= ?duration 1.438)
    :condition (and 
        (at start (and 
            (waiting s77)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.438)
            (increase (execute-times s77) 1)
            (finished s77)
            (action-frequency s77 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action storingforce_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s78)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s78) 1)
            (finished s78)
            (action-frequency s78 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action storingforce
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s78)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s78) 1)
            (finished s78)
            (action-frequency s78 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action shake_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s79)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 2.953)
            (increase (execute-times s79) 1)
            (finished s79)
            (action-frequency s79 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action shake
    :parameters ()
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s79)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 2.953)
            (increase (execute-times s79) 1)
            (finished s79)
            (action-frequency s79 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action handsupanddown_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s80)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s80) 1)
            (finished s80)
            (action-frequency s80 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action handsupanddown
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s80)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 1.875)
            (increase (execute-times s80) 1)
            (finished s80)
            (action-frequency s80 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action saluteswingarm_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s81)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.945)
            (increase (execute-times s81) 1)
            (finished s81)
            (action-frequency s81 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action saluteswingarm
    :parameters ()
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s81)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.945)
            (increase (execute-times s81) 1)
            (finished s81)
            (action-frequency s81 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action rightuppercut_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.969)
    :condition (and 
        (at start (and 
            (waiting s82)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.969)
            (increase (execute-times s82) 1)
            (finished s82)
            (action-frequency s82 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action rightuppercut
    :parameters ()
    :duration (= ?duration 0.969)
    :condition (and 
        (at start (and 
            (waiting s82)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.969)
            (increase (execute-times s82) 1)
            (finished s82)
            (action-frequency s82 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action lefthook_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 0.586)
    :condition (and 
        (at start (and 
            (waiting s83)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 0.586)
            (increase (execute-times s83) 1)
            (finished s83)
            (action-frequency s83 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action lefthook
    :parameters ()
    :duration (= ?duration 0.586)
    :condition (and 
        (at start (and 
            (waiting s83)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
        ))
    )
    :effect (and 
        (at start (and
            (not (is_body_free hand-right))
            (not (is_body_free hand-left))
            (not (is_body_free leg-right))
            (not (is_body_free leg-left))
            (not (at-body-space-y forward))
            (not (at-body-space-z half-squat))
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 0.586)
            (increase (execute-times s83) 1)
            (finished s83)
            (action-frequency s83 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action wilddance_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s84)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
            
        ))
        (at end (and 
            (increase (dance-time) 2.953)
            (increase (execute-times s84) 1)
            (finished s84)
            (action-frequency s84 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action wilddance
    :parameters ()
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s84)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
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
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 2.953)
            (increase (execute-times s84) 1)
            (finished s84)
            (action-frequency s84 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action waveleftandright_beat
    :parameters ( ?beat - beat)
    :duration (= ?duration 2.688)
    :condition (and 
        (at start (and 
            (waiting s85)
            (at-beat ?beat)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
            
        ))
        (at end (and 
            (increase (dance-time) 2.688)
            (increase (execute-times s85) 1)
            (finished s85)
            (action-frequency s85 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            (increase (beat-satisfy-times) 1)
            
        ))
    )
)

(:durative-action waveleftandright
    :parameters ()
    :duration (= ?duration 2.688)
    :condition (and 
        (at start (and 
            (waiting s85)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
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
            (not (at-body-space-hand others))
        ))
        (at end (and 
            (increase (dance-time) 2.688)
            (increase (execute-times s85) 1)
            (finished s85)
            (action-frequency s85 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


)
