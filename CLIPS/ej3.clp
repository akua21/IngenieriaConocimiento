(deftemplate params
	(slot original
		(type INTEGER))
	(slot num
		(type INTEGER))
	(slot it
		(type INTEGER))
)	

(deffacts hechos-iniciales
	(elemento 5)
)

(defrule guardar-params
	(declare (salience 10))
	?elem <- (elemento ?x)
	(test (> ?x 0))
	=>
	(assert (params (original ?x) (num ?x) (it (- ?x 1))))
	(retract ?elem)
)

(defrule factorial
	(declare (salience 20))
	?params <- (params (num ?x) (it ?i))
	(test (neq ?i 1))
	=>
	(modify ?params (num (* ?x ?i)) (it (- ?i 1)))
)

(defrule parada
	(declare (salience 30))
	?params <- (params (original ?o) (num ?x) (it ?i))
	(test (eq ?i 1))
	=>
	(assert (elemento ?x))
	(retract ?params)
	(printout t "El factorial de " ?o " es: " ?x crlf)
	(halt)
)
