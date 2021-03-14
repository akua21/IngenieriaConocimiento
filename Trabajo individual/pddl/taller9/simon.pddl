;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; simon  world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain SIMON)
	(:requirements :strips :typing :fluents)
	(:types player - object
	        counter colour - object
	        hi-bye - object
		)
	(:constants human robot - player
		    zero - counter) 
	(:predicates (turn ?p - player)
		     (coloured ?i - counter ?c - colour)
		     (current-instant ?i - counter)
		     (current-round ?r - counter)
		     (round-limit ?r - counter)
		     (round-played ?r - counter)
		     (game-over)
		     (next ?c1 ?c2 - counter)
		     (previous-colour ?c - colour)
		     (greeting ?g - hi-bye)
		     (farewell ?f - hi-bye)
		     )
	(:functions (colour-penalty)
		    (colour-used ?c - colour)
	            (colour-limit )
		    )
		    


(:action say-hello
	:parameters (?g - hi-bye)
	:precondition (and (not (greeting ?g)))
	:effect (and (greeting ?g))
)

(:action say-goodbye
	:parameters (?f - hi-bye)
	:precondition (and (farewell ?f))
	:effect (game-over)
)


(:action finish-game
	 :parameters (?rc - counter ?f - hi-bye) 
	 :precondition
	 (and (round-limit ?rc) (round-played ?rc)
	      (forall (?c - colour) (>= (colour-used ?c) (colour-limit)))
	      )
	 :effect
		(and (farewell ?f))
)


(:action NAOrobot-plays
	 :parameters ( ?r - counter ?c - colour ?ic  - counter ?g - hi-bye)
	 :vars (?cp - colour  ?in ?rl ?rn - counter)
	 :precondition (and (current-instant ?ic) (current-round ?r) (not (= ?r ?ic)) (next ?ic ?in)
			    (turn robot) (previous-colour ?cp) (not (previous-colour ?c))
                            (round-limit ?rl) (next ?rl ?rn) (not (= ?rn ?r)) (greeting ?g) 
			    )
			    
	 :effect 
	 (and (coloured ?ic ?c)
	      (not (current-instant ?ic)) (current-instant ?in) 
	      (not (previous-colour ?cp)) (previous-colour ?c)
	      (increase (colour-penalty) (colour-used ?c)) ;; metrica dependiente del estado, no tragan los planners
	      (increase (colour-used ?c) 1)
	 )
)







(:action change-human
	 :parameters (?ic  - counter)	
	 :precondition (and (current-instant ?ic) (current-round ?ic) (turn robot))
	 :effect
	 (and (not (turn robot)) (turn human)
	      (not (current-instant ?ic)) (current-instant zero))
)


(:action NAOcheck-human
	 :parameters (?c - colour  ?ic - counter)
	 :vars (?in ?r - counter)
	 :precondition
	 (and (current-instant ?ic) (current-round ?r) (not (= ?ic ?r)) (next ?ic ?in)
	      (turn human)  (coloured ?ic ?c) 
	      )
	 :effect
		(and (not (coloured ?ic ?c)) 
		     (not (current-instant ?ic)) (current-instant ?in))
) 

(:action new-round
	 :parameters (?r ?rn  - counter)
	 :precondition
	 (and (turn human) (current-instant ?r) (current-round ?r)
	      (next ?r ?rn))
	 :effect
	 (and (not (current-round ?r)) (current-round ?rn)
	      (not (turn human)) (turn robot)
	      (not (current-instant ?r)) (current-instant zero)
	      (round-played ?r)
	      )
)





)

