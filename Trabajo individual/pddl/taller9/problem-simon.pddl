(define (problem p1)
(:domain SIMON)
(:objects blue red yellow green - colour
	  one two three four five six seven eight nine ten - counter
	  speak - hi-bye)
(:init 
       (round-limit three) 
       (current-round one) (current-instant zero) 
       (turn robot) 
       (previous-colour blue)
       (next zero one) (next one two) (next two three) (next three four) (next four five) (next five six) (next six seven) (next seven eight) (next eight nine) (next nine ten)
       (= (colour-penalty) 0)   

       (= (colour-used blue) 0)   
       (= (colour-used red) 0)   
       (= (colour-used green) 0)   
       (= (colour-used yellow) 0)
       (= (colour-limit) 1)   

       )

(:goal (game-over) )

(:metric minimize (colour-penalty))

)
