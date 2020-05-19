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
    
)

(:functions ;todo: define numeric functions here
    (dance-time)  ; Dance Time
    (execute-times ?s - state)  ; Number of Action performed
    (action-rate ?rate - rate)  ; Action Using Rate
    (high-frequency-times)  ; Number of high frequency actions performed
    (inter-frequency-times)  ; Number of intermediate frequency actions performed
    
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


(:durative-action runningman
    :parameters ()
    :duration (= ?duration 1.992)
    :condition (and 
        (at start (and 
            (waiting s1)
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
            (increase (execute-times s1) 1)
            (finished s1)
            (action-frequency s1 high-frequency)
			(increase (high-frequency-times) 1)
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


(:durative-action leftrightwave
    :parameters ()
    :duration (= ?duration 1.844)
    :condition (and 
        (at start (and 
            (waiting s2)
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
            (increase (execute-times s2) 1)
            (finished s2)
            (action-frequency s2 high-frequency)
			(increase (high-frequency-times) 1)
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


(:durative-action handswavedown
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s3)
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
            (increase (execute-times s3) 1)
            (best-rate s3 ?rate)
            (finished s3)
            (action-frequency s3 high-frequency)
			(increase (high-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action elbowturn
    :parameters ()
    :duration (= ?duration 2.133)
    :condition (and 
        (at start (and 
            (waiting s4)
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
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action abandon
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s5)
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
            (increase (execute-times s5) 1)
            (best-rate s5 ?rate)
            (finished s5)
            (action-frequency s5 high-frequency)
			(increase (high-frequency-times) 1)
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


(:durative-action crossfingers
    :parameters ()
    :duration (= ?duration 0.781)
    :condition (and 
        (at start (and 
            (waiting s6)
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
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action shoulderrhythm
    :parameters ()
    :duration (= ?duration 0.789)
    :condition (and 
        (at start (and 
            (waiting s7)
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
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 intermediate-frequency)
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


(:durative-action handswaveup
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s8)
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
            (increase (execute-times s8) 1)
            (best-rate s8 ?rate)
            (finished s8)
            (action-frequency s8 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action righthandup
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s9)
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


(:durative-action parallelhands
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s10)
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
            (increase (execute-times s10) 1)
            (best-rate s10 ?rate)
            (finished s10)
            (action-frequency s10 intermediate-frequency)
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


(:durative-action taketheleft
    :parameters ()
    :duration (= ?duration 0.883)
    :condition (and 
        (at start (and 
            (waiting s11)
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
            (increase (execute-times s11) 1)
            (finished s11)
            (action-frequency s11 intermediate-frequency)
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


(:durative-action akimboraise
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.883 (action-rate ?rate)))
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
            (increase (dance-time) (* 0.883 (action-rate ?rate)))
            (increase (execute-times s12) 1)
            (best-rate s12 ?rate)
            (finished s12)
            (action-frequency s12 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action spreadwings
    :parameters ()
    :duration (= ?duration 1.406)
    :condition (and 
        (at start (and 
            (waiting s13)
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


(:durative-action lefthandsobliqueparallel
    :parameters ()
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s14)
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
            (increase (execute-times s14) 1)
            (finished s14)
            (action-frequency s14 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action leftrightout
    :parameters ()
    :duration (= ?duration 3.93)
    :condition (and 
        (at start (and 
            (waiting s15)
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
            (increase (execute-times s15) 1)
            (finished s15)
            (action-frequency s15 intermediate-frequency)
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


(:durative-action sidestepleft
    :parameters ()
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s16)
            
            
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
            (increase (execute-times s16) 1)
            (finished s16)
            (action-frequency s16 intermediate-frequency)
			(increase (inter-frequency-times) 1)

            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action righthandfan
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.203 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s17)
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
            (increase (execute-times s17) 1)
            (best-rate s17 ?rate)
            (finished s17)
            (action-frequency s17 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action sidemovement
    :parameters ()
    :duration (= ?duration 1.391)
    :condition (and 
        (at start (and 
            (waiting s18)
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
            (increase (execute-times s18) 1)
            (finished s18)
            (action-frequency s18 intermediate-frequency)
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


(:durative-action leftsidekick
    :parameters ()
    :duration (= ?duration 0.922)
    :condition (and 
        (at start (and 
            (waiting s19)
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
            (increase (execute-times s19) 1)
            (finished s19)
            (action-frequency s19 intermediate-frequency)
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


(:durative-action armsupward
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s20)
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
            (increase (execute-times s20) 1)
            (best-rate s20 ?rate)
            (finished s20)
            (action-frequency s20 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action motionhands
    :parameters ()
    :duration (= ?duration 0.695)
    :condition (and 
        (at start (and 
            (waiting s21)
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
            (increase (execute-times s21) 1)
            (finished s21)
            (action-frequency s21 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action parallelhandsakimboerect
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.805 (action-rate ?rate)))
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
            (increase (dance-time) (* 1.805 (action-rate ?rate)))
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


(:durative-action leftrightrhythm
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s23)
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
            (increase (execute-times s23) 1)
            (best-rate s23 ?rate)
            (finished s23)
            (action-frequency s23 intermediate-frequency)
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


(:durative-action scratchinghead
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s24)
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
            (increase (execute-times s24) 1)
            (best-rate s24 ?rate)
            (finished s24)
            (action-frequency s24 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action handappearance
    :parameters ()
    :duration (= ?duration 0.969)
    :condition (and 
        (at start (and 
            (waiting s25)
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
            (increase (execute-times s25) 1)
            (finished s25)
            (action-frequency s25 intermediate-frequency)
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


(:durative-action twistwaist
    :parameters ()
    :duration (= ?duration 0.531)
    :condition (and 
        (at start (and 
            (waiting s26)
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
            (increase (execute-times s26) 1)
            (finished s26)
            (action-frequency s26 intermediate-frequency)
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


(:durative-action handfly
    :parameters ()
    :duration (= ?duration 1.75)
    :condition (and 
        (at start (and 
            (waiting s27)
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
            (increase (execute-times s27) 1)
            (finished s27)
            (action-frequency s27 intermediate-frequency)
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


(:durative-action drumroll
    :parameters ()
    :duration (= ?duration 1.828)
    :condition (and 
        (at start (and 
            (waiting s28)
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
            (increase (execute-times s28) 1)
            (finished s28)
            (action-frequency s28 intermediate-frequency)
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


(:durative-action finesseswing
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s29)
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
            (increase (execute-times s29) 1)
            (best-rate s29 ?rate)
            (finished s29)
            (action-frequency s29 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action openheartleft
    :parameters ()
    :duration (= ?duration 0.703)
    :condition (and 
        (at start (and 
            (waiting s30)
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
            (increase (execute-times s30) 1)
            (finished s30)
            (action-frequency s30 intermediate-frequency)
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


(:durative-action shockhands
    :parameters ()
    :duration (= ?duration 1.0)
    :condition (and 
        (at start (and 
            (waiting s31)
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
            (increase (execute-times s31) 1)
            (finished s31)
            (action-frequency s31 intermediate-frequency)
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


(:durative-action enlargebosmhoodwink
    :parameters ()
    :duration (= ?duration 0.906)
    :condition (and 
        (at start (and 
            (waiting s32)
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
            (increase (execute-times s32) 1)
            (finished s32)
            (action-frequency s32 intermediate-frequency)
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


(:durative-action leftprotest
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.703 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s33)
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
            (increase (execute-times s33) 1)
            (best-rate s33 ?rate)
            (finished s33)
            (action-frequency s33 intermediate-frequency)
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


(:durative-action rightswing
    :parameters ()
    :duration (= ?duration 1.602)
    :condition (and 
        (at start (and 
            (waiting s34)
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
            (increase (execute-times s34) 1)
            (finished s34)
            (action-frequency s34 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y backward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action shakehands
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.805 (action-rate ?rate)))
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
            (increase (dance-time) (* 0.805 (action-rate ?rate)))
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


(:durative-action heavypendulum
    :parameters ()
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s36)
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
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action raisehandanddropdown
    :parameters ()
    :duration (= ?duration 2.703)
    :condition (and 
        (at start (and 
            (waiting s37)
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


(:durative-action liftthechest
    :parameters ()
    :duration (= ?duration 1.797)
    :condition (and 
        (at start (and 
            (waiting s38)
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
            (increase (execute-times s38) 1)
            (finished s38)
            (action-frequency s38 intermediate-frequency)
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


(:durative-action leftturn
    :parameters ()
    :duration (= ?duration 1.664)
    :condition (and 
        (at start (and 
            (waiting s39)
            
            
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
            (increase (execute-times s39) 1)
            (finished s39)
            (action-frequency s39 intermediate-frequency)
			(increase (inter-frequency-times) 1)

            
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action mergehand
    :parameters ()
    :duration (= ?duration 0.703)
    :condition (and 
        (at start (and 
            (waiting s40)
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
            (increase (execute-times s40) 1)
            (finished s40)
            (action-frequency s40 intermediate-frequency)
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


(:durative-action fastadvance
    :parameters ()
    :duration (= ?duration 0.516)
    :condition (and 
        (at start (and 
            (waiting s41)
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
            (increase (execute-times s41) 1)
            (finished s41)
            (action-frequency s41 intermediate-frequency)
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


(:durative-action leftfuels
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s42)
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
            (increase (execute-times s42) 1)
            (best-rate s42 ?rate)
            (finished s42)
            (action-frequency s42 intermediate-frequency)
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


(:durative-action handupanddown
    :parameters ()
    :duration (= ?duration 3.0)
    :condition (and 
        (at start (and 
            (waiting s43)
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
            (increase (execute-times s43) 1)
            (finished s43)
            (action-frequency s43 intermediate-frequency)
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


(:durative-action rightlean
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.508 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s44)
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
            (increase (execute-times s44) 1)
            (best-rate s44 ?rate)
            (finished s44)
            (action-frequency s44 intermediate-frequency)
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


(:durative-action lefthandwave
    :parameters (?rate - rate)
    :duration (= ?duration (* 2.602 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s45)
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
            (increase (execute-times s45) 1)
            (best-rate s45 ?rate)
            (finished s45)
            (action-frequency s45 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action akimbo
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.609 (action-rate ?rate)))
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
            (increase (dance-time) (* 0.609 (action-rate ?rate)))
            (increase (execute-times s46) 1)
            (best-rate s46 ?rate)
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


(:durative-action hitchest
    :parameters ()
    :duration (= ?duration 0.906)
    :condition (and 
        (at start (and 
            (waiting s47)
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
            (increase (execute-times s47) 1)
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


(:durative-action akimbodown
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s48)
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
            (increase (execute-times s48) 1)
            (best-rate s48 ?rate)
            (finished s48)
            (action-frequency s48 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action leftpunch
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s49)
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
            (increase (execute-times s49) 1)
            (best-rate s49 ?rate)
            (finished s49)
            (action-frequency s49 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action shockhandstochest
    :parameters ()
    :duration (= ?duration 1.312)
    :condition (and 
        (at start (and 
            (waiting s50)
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
            (increase (execute-times s50) 1)
            (finished s50)
            (action-frequency s50 intermediate-frequency)
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


(:durative-action beatupanddown
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.797 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s52)
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
            (increase (execute-times s52) 1)
            (best-rate s52 ?rate)
            (finished s52)
            (action-frequency s52 intermediate-frequency)
			(increase (inter-frequency-times) 1)
(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y centre)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            
        ))
    )
)


(:durative-action rotatingrighthand
    :parameters ()
    :duration (= ?duration 1.781)
    :condition (and 
        (at start (and 
            (waiting s53)
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
            (increase (execute-times s53) 1)
            (finished s53)
            (action-frequency s53 intermediate-frequency)
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


(:durative-action upwardpunches
    :parameters ()
    :duration (= ?duration 2.188)
    :condition (and 
        (at start (and 
            (waiting s54)
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
            (increase (execute-times s54) 1)
            (finished s54)
            (action-frequency s54 intermediate-frequency)
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


(:durative-action lefthandbend
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s55)
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
            (increase (execute-times s55) 1)
            (finished s55)
            (action-frequency s55 low-frequency)
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


(:durative-action wilddance
    :parameters ()
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s56)
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
            (increase (execute-times s56) 1)
            (finished s56)
            (action-frequency s56 low-frequency)
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


(:durative-action dancingyouth
    :parameters ()
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s57)
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
            (increase (execute-times s57) 1)
            (finished s57)
            (action-frequency s57 low-frequency)
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


(:durative-action handsbendinward
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s58)
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
            (increase (execute-times s58) 1)
            (finished s58)
            (action-frequency s58 low-frequency)
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


(:durative-action storingforce
    :parameters ()
    :duration (= ?duration 1.875)
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
            (increase (dance-time) 1.875)
            (increase (execute-times s59) 1)
            (finished s59)
            (action-frequency s59 low-frequency)
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


(:durative-action handheadfoot
    :parameters ()
    :duration (= ?duration 1.875)
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
            (increase (dance-time) 1.875)
            (increase (execute-times s60) 1)
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


(:durative-action lefthook
    :parameters ()
    :duration (= ?duration 0.586)
    :condition (and 
        (at start (and 
            (waiting s61)
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
            (increase (execute-times s61) 1)
            (finished s61)
            (action-frequency s61 low-frequency)
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


(:durative-action handscircle
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s62)
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


(:durative-action soldiersalute
    :parameters ()
    :duration (= ?duration 1.195)
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
            (increase (dance-time) 1.195)
            (increase (execute-times s63) 1)
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


(:durative-action putuphandsdown
    :parameters ()
    :duration (= ?duration 0.992)
    :condition (and 
        (at start (and 
            (waiting s64)
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
            (increase (execute-times s64) 1)
            (finished s64)
            (action-frequency s64 low-frequency)
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


(:durative-action allforme
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
            (increase (execute-times s65) 1)
            (best-rate s65 ?rate)
            (finished s65)
            (action-frequency s65 low-frequency)
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


(:durative-action kettle
    :parameters ()
    :duration (= ?duration 1.312)
    :condition (and 
        (at start (and 
            (waiting s66)
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
            (increase (execute-times s66) 1)
            (finished s66)
            (action-frequency s66 low-frequency)
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


(:durative-action shake
    :parameters ()
    :duration (= ?duration 2.953)
    :condition (and 
        (at start (and 
            (waiting s67)
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
            (increase (execute-times s67) 1)
            (finished s67)
            (action-frequency s67 low-frequency)
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


(:durative-action runaround
    :parameters ()
    :duration (= ?duration 2.312)
    :condition (and 
        (at start (and 
            (waiting s68)
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


(:durative-action shakeelbow
    :parameters (?rate - rate)
    :duration (= ?duration (* 3.0 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s69)
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
            (increase (execute-times s69) 1)
            (best-rate s69 ?rate)
            (finished s69)
            (action-frequency s69 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
        ))
    )
)


(:durative-action righthook
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.117 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s70)
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
            (increase (execute-times s70) 1)
            (best-rate s70 ?rate)
            (finished s70)
            (action-frequency s70 low-frequency)
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


(:durative-action liftingarm
    :parameters ()
    :duration (= ?duration 1.875)
    :condition (and 
        (at start (and 
            (waiting s71)
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
            (increase (execute-times s71) 1)
            (finished s71)
            (action-frequency s71 low-frequency)
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


(:durative-action power
    :parameters ()
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s72)
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
            (increase (execute-times s72) 1)
            (finished s72)
            (action-frequency s72 low-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            
            
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand others)
            
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


(:durative-action leftattack
    :parameters ()
    :duration (= ?duration 1.438)
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
            (increase (dance-time) 1.438)
            (increase (execute-times s74) 1)
            (finished s74)
            (action-frequency s74 low-frequency)
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


(:durative-action rightblock
    :parameters ()
    :duration (= ?duration 1.0)
    :condition (and 
        (at start (and 
            (waiting s75)
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
            (increase (execute-times s75) 1)
            (finished s75)
            (action-frequency s75 low-frequency)
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


(:durative-action roar
    :parameters ()
    :duration (= ?duration 2.133)
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
            (increase (dance-time) 2.133)
            (increase (execute-times s76) 1)
            (finished s76)
            (action-frequency s76 low-frequency)
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


(:durative-action saluteswingarm
    :parameters ()
    :duration (= ?duration 2.945)
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
            (increase (dance-time) 2.945)
            (increase (execute-times s77) 1)
            (finished s77)
            (action-frequency s77 low-frequency)
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


(:durative-action squat
    :parameters ()
    :duration (= ?duration 1.602)
    :condition (and 
        (at start (and 
            (waiting s78)
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
            (increase (execute-times s78) 1)
            (finished s78)
            (action-frequency s78 low-frequency)
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


(:durative-action rightuppercut
    :parameters ()
    :duration (= ?duration 0.969)
    :condition (and 
        (at start (and 
            (waiting s79)
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
            (increase (execute-times s79) 1)
            (finished s79)
            (action-frequency s79 low-frequency)
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


(:durative-action swinghandsputup
    :parameters ()
    :duration (= ?duration 2.172)
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
            (increase (dance-time) 2.172)
            (increase (execute-times s81) 1)
            (finished s81)
            (action-frequency s81 low-frequency)
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


(:durative-action verticalarm
    :parameters ()
    :duration (= ?duration 2.602)
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
            (increase (dance-time) 2.602)
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


(:durative-action swinghandsfootside
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s83)
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
            (increase (execute-times s83) 1)
            (best-rate s83 ?rate)
            (finished s83)
            (action-frequency s83 low-frequency)
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


(:durative-action swingshake
    :parameters (?rate - rate)
    :duration (= ?duration (* 1.875 (action-rate ?rate)))
    :condition (and 
        (at start (and 
            (waiting s84)
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
            (increase (execute-times s84) 1)
            (best-rate s84 ?rate)
            (finished s84)
            (action-frequency s84 low-frequency)
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
