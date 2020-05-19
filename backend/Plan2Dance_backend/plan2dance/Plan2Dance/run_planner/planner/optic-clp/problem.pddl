(define (problem robot-0) 
(:domain robot)
(:objects
    slow - rate
    mid - rate
    fast - rate
)
(:init
    (is_body_free)
    (= (dance-time) 0)
    (= (action-rate slow) 1.15)
    (= (action-rate mid) 1)
    (= (action-rate fast) 0.85)
    (= (at_floor_space) 0)
    (= (control_the_transition) 0)
    (= (all_action_times) 0)
    (waiting s41)
(waiting s17)
(waiting s32)
(at_space_y y_mid)
    (at_space_z z_up)
    (at_space_y y_front)
    (at_space_z z_down)
    (at_hand prethoracic)
    (at_hand others)
(= (action-times s41) 0)
(= (action-times s17) 0)
(= (action-times s32) 0)

)
(:goal (and
    (> (dance-time) 5.67)
(< (dance-time) 6.27)
(forall (?s - state) 
             (preference p0 (best-rate ?s mid))
)
(preference p1
            (sometime-after (finished s17) (finished s32))
)
)
(:metric minimize (+
(control_the_transition) 
(is-violated p1)
(* 5 (is-violated p0))
) 
)
)
