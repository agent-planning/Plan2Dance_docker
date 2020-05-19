(define (domain d-robot-7)
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
    
)

(:functions ;todo: define numeric functions here
    (dance-time)  ; Dance Time
    (execute-times ?s - state)  ; Number of Action performed
    (action-rate ?rate - rate)  ; Action Using Rate
    (high-frequency-times)  ; Number of high frequency actions performed
    (inter-frequency-times)  ; Number of intermediate frequency actions performed
    (coherent-satisfy ?s - state ?st - state)
                
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


(:durative-action afterwipe
    :parameters ()
    :duration (= ?duration 5.984)
    :condition (and 
        (at start (and 
            (waiting s1)
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
            (increase (dance-time) 5.984)
            (increase (execute-times s1) 1)
            (finished s1)
            (action-frequency s1 dance-frequency)
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


(:durative-action alabez_AfterWipe_coherent
    :parameters ()
    :duration (= ?duration 3.047)
    :condition (and 
        (at start (and 
            (waiting s2)
            (finished s1)
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
            (increase (coherent-satisfy s1 s2) 1)
        ))
        (at end (and 
            (increase (dance-time) 3.047)
            (increase (execute-times s2) 1)
            (finished s2)
            (action-frequency s2 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (not (finished s1))
            
        ))
    )
)

(:durative-action alabez
    :parameters ()
    :duration (= ?duration 3.047)
    :condition (and 
        (at start (and 
            (waiting s2)
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
            (increase (dance-time) 3.047)
            (increase (execute-times s2) 1)
            (finished s2)
            (action-frequency s2 dance-frequency)
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


(:durative-action frontleglift_Alabez_coherent
    :parameters ()
    :duration (= ?duration 3.805)
    :condition (and 
        (at start (and 
            (waiting s3)
            (finished s2)
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
            (increase (coherent-satisfy s2 s3) 1)
        ))
        (at end (and 
            (increase (dance-time) 3.805)
            (increase (execute-times s3) 1)
            (finished s3)
            (action-frequency s3 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z half-squat)
            (at-body-space-hand chest)
            (not (finished s2))
            
        ))
    )
)

(:durative-action frontleglift
    :parameters ()
    :duration (= ?duration 3.805)
    :condition (and 
        (at start (and 
            (waiting s3)
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
            (increase (dance-time) 3.805)
            (increase (execute-times s3) 1)
            (finished s3)
            (action-frequency s3 dance-frequency)
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


(:durative-action frontwipe_HandPointFour_coherent
    :parameters ()
    :duration (= ?duration 7.812)
    :condition (and 
        (at start (and 
            (waiting s4)
            (finished s5)
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
            (increase (coherent-satisfy s5 s4) 1)
        ))
        (at end (and 
            (increase (dance-time) 7.812)
            (increase (execute-times s4) 1)
            (finished s4)
            (action-frequency s4 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s5))
            
        ))
    )
)

(:durative-action frontwipe_HandPointOne_coherent
    :parameters ()
    :duration (= ?duration 7.812)
    :condition (and 
        (at start (and 
            (waiting s4)
            (finished s6)
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
            (increase (coherent-satisfy s6 s4) 1)
        ))
        (at end (and 
            (increase (dance-time) 7.812)
            (increase (execute-times s4) 1)
            (finished s4)
            (action-frequency s4 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s6))
            
        ))
    )
)

(:durative-action frontwipe_HandsExchange_coherent
    :parameters ()
    :duration (= ?duration 7.812)
    :condition (and 
        (at start (and 
            (waiting s4)
            (finished s7)
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
            (increase (coherent-satisfy s7 s4) 1)
        ))
        (at end (and 
            (increase (dance-time) 7.812)
            (increase (execute-times s4) 1)
            (finished s4)
            (action-frequency s4 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s7))
            
        ))
    )
)

(:durative-action frontwipe
    :parameters ()
    :duration (= ?duration 7.812)
    :condition (and 
        (at start (and 
            (waiting s4)
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
            (increase (dance-time) 7.812)
            (increase (execute-times s4) 1)
            (finished s4)
            (action-frequency s4 dance-frequency)
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


(:durative-action handpointfour_HandPointOne_coherent
    :parameters ()
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s5)
            (finished s6)
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
            (increase (coherent-satisfy s6 s5) 1)
        ))
        (at end (and 
            (increase (dance-time) 2.0)
            (increase (execute-times s5) 1)
            (finished s5)
            (action-frequency s5 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s6))
            
        ))
    )
)

(:durative-action handpointfour_FrontWipe_coherent
    :parameters ()
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s5)
            (finished s4)
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
            (increase (coherent-satisfy s4 s5) 1)
        ))
        (at end (and 
            (increase (dance-time) 2.0)
            (increase (execute-times s5) 1)
            (finished s5)
            (action-frequency s5 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s4))
            
        ))
    )
)

(:durative-action handpointfour_PointOne_coherent
    :parameters ()
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s5)
            (finished s9)
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
            (increase (coherent-satisfy s9 s5) 1)
        ))
        (at end (and 
            (increase (dance-time) 2.0)
            (increase (execute-times s5) 1)
            (finished s5)
            (action-frequency s5 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s9))
            
        ))
    )
)

(:durative-action handpointfour
    :parameters ()
    :duration (= ?duration 2.0)
    :condition (and 
        (at start (and 
            (waiting s5)
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
            (increase (execute-times s5) 1)
            (finished s5)
            (action-frequency s5 dance-frequency)
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


(:durative-action handpointone_FrontWipe_coherent
    :parameters ()
    :duration (= ?duration 1.211)
    :condition (and 
        (at start (and 
            (waiting s6)
            (finished s4)
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
            (increase (coherent-satisfy s4 s6) 1)
        ))
        (at end (and 
            (increase (dance-time) 1.211)
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s4))
            
        ))
    )
)

(:durative-action handpointone_HandPointFour_coherent
    :parameters ()
    :duration (= ?duration 1.211)
    :condition (and 
        (at start (and 
            (waiting s6)
            (finished s5)
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
            (increase (coherent-satisfy s5 s6) 1)
        ))
        (at end (and 
            (increase (dance-time) 1.211)
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s5))
            
        ))
    )
)

(:durative-action handpointone_saluteSwingArm_coherent
    :parameters ()
    :duration (= ?duration 1.211)
    :condition (and 
        (at start (and 
            (waiting s6)
            (finished s14)
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
            (increase (coherent-satisfy s14 s6) 1)
        ))
        (at end (and 
            (increase (dance-time) 1.211)
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s14))
            
        ))
    )
)

(:durative-action handpointone
    :parameters ()
    :duration (= ?duration 1.211)
    :condition (and 
        (at start (and 
            (waiting s6)
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
            (increase (dance-time) 1.211)
            (increase (execute-times s6) 1)
            (finished s6)
            (action-frequency s6 dance-frequency)
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


(:durative-action handsexchange_HandPointFour_coherent
    :parameters ()
    :duration (= ?duration 6.328)
    :condition (and 
        (at start (and 
            (waiting s7)
            (finished s5)
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
            (increase (coherent-satisfy s5 s7) 1)
        ))
        (at end (and 
            (increase (dance-time) 6.328)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s5))
            
        ))
    )
)

(:durative-action handsexchange_FrontWipe_coherent
    :parameters ()
    :duration (= ?duration 6.328)
    :condition (and 
        (at start (and 
            (waiting s7)
            (finished s4)
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
            (increase (coherent-satisfy s4 s7) 1)
        ))
        (at end (and 
            (increase (dance-time) 6.328)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s4))
            
        ))
    )
)

(:durative-action handsexchange_HandPointFour_coherent
    :parameters ()
    :duration (= ?duration 6.328)
    :condition (and 
        (at start (and 
            (waiting s7)
            (finished s5)
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
            (increase (coherent-satisfy s5 s7) 1)
        ))
        (at end (and 
            (increase (dance-time) 6.328)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s5))
            
        ))
    )
)

(:durative-action handsexchange_PointOne_coherent
    :parameters ()
    :duration (= ?duration 6.328)
    :condition (and 
        (at start (and 
            (waiting s7)
            (finished s9)
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
            (increase (coherent-satisfy s9 s7) 1)
        ))
        (at end (and 
            (increase (dance-time) 6.328)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 dance-frequency)
			(is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y forward)
            (at-body-space-z stand)
            (at-body-space-hand chest)
            (not (finished s9))
            
        ))
    )
)

(:durative-action handsexchange
    :parameters ()
    :duration (= ?duration 6.328)
    :condition (and 
        (at start (and 
            (waiting s7)
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
            (increase (dance-time) 6.328)
            (increase (execute-times s7) 1)
            (finished s7)
            (action-frequency s7 dance-frequency)
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


(:durative-action pointfour
    :parameters ()
    :duration (= ?duration 2.711)
    :condition (and 
        (at start (and 
            (waiting s8)
            (is_body_free hand-right)
            (is_body_free hand-left)
            (is_body_free leg-right)
            (is_body_free leg-left)
            (at-body-space-y backward)
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
            (not (at-body-space-y backward))
            (not (at-body-space-z stand))
            (not (at-body-space-hand chest))
        ))
        (at end (and 
            (increase (dance-time) 2.711)
            (increase (execute-times s8) 1)
            (finished s8)
            (action-frequency s8 dance-frequency)
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


(:durative-action pointone
    :parameters ()
    :duration (= ?duration 1.25)
    :condition (and 
        (at start (and 
            (waiting s9)
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
            (increase (dance-time) 1.25)
            (increase (execute-times s9) 1)
            (finished s9)
            (action-frequency s9 dance-frequency)
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


(:durative-action pointonetopointseven
    :parameters ()
    :duration (= ?duration 1.758)
    :condition (and 
        (at start (and 
            (waiting s10)
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
            (increase (dance-time) 1.758)
            (increase (execute-times s10) 1)
            (finished s10)
            (action-frequency s10 dance-frequency)
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


(:durative-action pointthree
    :parameters ()
    :duration (= ?duration 0.789)
    :condition (and 
        (at start (and 
            (waiting s11)
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
            (increase (dance-time) 0.789)
            (increase (execute-times s11) 1)
            (finished s11)
            (action-frequency s11 dance-frequency)
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


(:durative-action pointtwo
    :parameters ()
    :duration (= ?duration 0.805)
    :condition (and 
        (at start (and 
            (waiting s12)
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
            (increase (dance-time) 0.805)
            (increase (execute-times s12) 1)
            (finished s12)
            (action-frequency s12 dance-frequency)
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


(:durative-action hitchest
    :parameters ()
    :duration (= ?duration 0.906)
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
            (increase (dance-time) 0.906)
            (increase (execute-times s13) 1)
            (finished s13)
            (action-frequency s13 common-frequency)
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


(:durative-action saluteswingarm
    :parameters ()
    :duration (= ?duration 2.945)
    :condition (and 
        (at start (and 
            (waiting s14)
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
            (increase (execute-times s14) 1)
            (finished s14)
            (action-frequency s14 common-frequency)
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


(:durative-action akimbo
    :parameters (?rate - rate)
    :duration (= ?duration (* 0.609 (action-rate ?rate)))
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
            (increase (dance-time) (* 0.609 (action-rate ?rate)))
            (increase (execute-times s15) 1)
            (finished s15)
            (action-frequency s15 common-frequency)
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


)
