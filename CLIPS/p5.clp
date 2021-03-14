(defrule  R0
=>
	(assert (valor 10))
	(assert (valor 2))
	(assert (valor 6))
	(assert (valor 12))
	(printout t "R0" crlf))

(defrule R1
	(declare (salience 20))
	(not (elemento ?))
	(valor ?valor)
=>
	(assert (elemento ?valor))
	(printout t "R1" crlf))

(defrule R2
	(declare (salience 10))
	?e <- (elemento ?v1)(valor ?v2)
	(test (< ?v2 ?v1))
=>
	(retract ?e)
	(assert (elemento ?v2))
	(printout t "R2" crlf))
	
(defrule R3
	(declare (salience 5))
	?e<-(elemento ?v1)
	?v<-(valor ?v1)
=>
	(printout t ?v1 crlf)
	(retract ?e)(retract ?v)
	(printout t "R3" crlf))
	
