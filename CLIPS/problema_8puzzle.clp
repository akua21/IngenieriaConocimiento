; PROBLEMA 8 PUZZLE

(defclass CASILLA (is-a INITIAL-OBJECT)
	(slot x
		(type INTEGER))
	(slot y
		(type INTEGER))
	(slot valor
		(type INTEGER)
		(default 100))
)

(deffacts valores
	(val 0)
	(val 1)
	(val 2)
	(val 3)
	(val 4)
	(val 5)
	(val 6)
	(val 7)
	(val 8)
)


(definstances casillas
	([c11] of CASILLA (x 1) (y 1))
	([c21] of CASILLA (x 2) (y 1))
	([c31] of CASILLA (x 3) (y 1))
	([c12] of CASILLA (x 1) (y 2))
	([c22] of CASILLA (x 2) (y 2))
	([c32] of CASILLA (x 3) (y 2))
	([c13] of CASILLA (x 1) (y 3))
	([c23] of CASILLA (x 2) (y 3))
	([c33] of CASILLA (x 3) (y 3))
)


(defrule estrategia
	(declare (salience 4))
	=>
	(set-strategy random)	
)


(defrule estado-inicial
	(declare (salience 3))
	?c <- (object (is-a CASILLA) (x ?x) (y ?y) (valor 100))
	?val <- (val ?v)
	=>
	(modify-instance ?c (valor ?v))
	(retract ?val)
	(printout t "Inicializado valor de casilla " ?x "-" ?y " a " ?v crlf) 
)


(defrule arriba
	(declare (salience 1))
	?c <- (object (is-a CASILLA) (x ?x) (y ?y) (valor 0))
	?c1 <- (object (is-a CASILLA) (x ?x) (y ?y1) (valor ?v))
	(test (= ?y1 (- ?y 1)))
	=>
	(modify-instance ?c (valor ?v))
	(modify-instance ?c1 (valor 0))
	(printout t "La casilla con valor 0 ha cambiado a ser la " ?x "-" ?y1 crlf) 
)
	
(defrule abajo
	(declare (salience 1))
	?c <- (object (is-a CASILLA) (x ?x) (y ?y) (valor 0))
	?c1 <- (object (is-a CASILLA) (x ?x) (y ?y1) (valor ?v))
	(test (= ?y1 (+ ?y 1)))
	=>
	(modify-instance ?c (valor ?v))
	(modify-instance ?c1 (valor 0))
	(printout t "La casilla con valor 0 ha cambiado a ser la " ?x "-" ?y1 crlf) 
)

(defrule derecha
	(declare (salience 1))
	?c <- (object (is-a CASILLA) (x ?x) (y ?y) (valor 0))
	?c1 <- (object (is-a CASILLA) (x ?x1) (y ?y) (valor ?v))
	(test (= ?x1 (+ ?x 1)))
	=>
	(modify-instance ?c (valor ?v))
	(modify-instance ?c1 (valor 0))
	(printout t "La casilla con valor 0 ha cambiado a ser la " ?x1 "-" ?y crlf) 
)

(defrule izquierda
	(declare (salience 1))
	?c <- (object (is-a CASILLA) (x ?x) (y ?y) (valor 0))
	?c1 <- (object (is-a CASILLA) (x ?x1) (y ?y) (valor ?v))
	(test (= ?x1 (- ?x 1)))
	=>
	(modify-instance ?c (valor ?v))
	(modify-instance ?c1 (valor 0))
	(printout t "La casilla con valor 0 ha cambiado a ser la " ?x1 "-" ?y crlf) 
)
	

(defrule fin
	(declare (salience 2))
	(object (is-a CASILLA) (x 1) (y 1) (valor 1)) 
	(object (is-a CASILLA) (x 2) (y 1) (valor 2))
	(object (is-a CASILLA) (x 3) (y 1) (valor 3)) 
	(object (is-a CASILLA) (x 1) (y 2) (valor 4))
	(object (is-a CASILLA) (x 2) (y 2) (valor 5)) 
	(object (is-a CASILLA) (x 3) (y 2) (valor 6))
	(object (is-a CASILLA) (x 1) (y 3) (valor 7)) 
	(object (is-a CASILLA) (x 2) (y 3) (valor 8))
	(object (is-a CASILLA) (x 3) (y 3) (valor 0))
	=>
	(printout t "Solución encontrada" crlf) 
	(halt)
)


;FIRE    1 estrategia: *
;FIRE    2 estado-inicial: [c33],f-3
;Inicializado valor de casilla 3-3 a 2
;FIRE    3 estado-inicial: [c23],f-7
;Inicializado valor de casilla 2-3 a 6
;FIRE    4 estado-inicial: [c31],f-8
;Inicializado valor de casilla 3-1 a 7
;FIRE    5 estado-inicial: [c22],f-6
;Inicializado valor de casilla 2-2 a 5
;FIRE    6 estado-inicial: [c21],f-2
;Inicializado valor de casilla 2-1 a 1
;FIRE    7 estado-inicial: [c32],f-1
;Inicializado valor de casilla 3-2 a 0
;FIRE    8 estado-inicial: [c13],f-9
;Inicializado valor de casilla 1-3 a 8
;FIRE    9 estado-inicial: [c12],f-4
;Inicializado valor de casilla 1-2 a 3
;FIRE   10 estado-inicial: [c11],f-5
;Inicializado valor de casilla 1-1 a 4
;FIRE   11 arriba: [c32],[c31]
;La casilla con valor 0 ha cambiado a ser la 3-1
;FIRE   12 izquierda: [c31],[c21]
;La casilla con valor 0 ha cambiado a ser la 2-1
;FIRE   13 izquierda: [c21],[c11]
;La casilla con valor 0 ha cambiado a ser la 1-1
;FIRE   14 derecha: [c11],[c21]
;La casilla con valor 0 ha cambiado a ser la 2-1
;FIRE   15 derecha: [c21],[c31]
;La casilla con valor 0 ha cambiado a ser la 3-1
;FIRE   16 izquierda: [c31],[c21]
;La casilla con valor 0 ha cambiado a ser la 2-1
;FIRE   17 abajo: [c21],[c22]
;La casilla con valor 0 ha cambiado a ser la 2-2
;FIRE   18 arriba: [c22],[c21]
;La casilla con valor 0 ha cambiado a ser la 2-1
;FIRE   19 abajo: [c21],[c22]
;La casilla con valor 0 ha cambiado a ser la 2-2
;FIRE   20 derecha: [c22],[c32]
;La casilla con valor 0 ha cambiado a ser la 3-2


