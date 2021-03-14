; Define la plantilla para la jarra
(deftemplate jarra
	(slot litros
		(type INTEGER)
		(default 0))
	(slot capacidad
		(type INTEGER))
)

; Inicializa la base de hechos
; (defrule estado-inicial
;  =>
;  (assert (jarra (capacidad 3)))
;  (assert (jarra (capacidad 4))))

(deffacts estado_inicial_jarras
	(jarra (capacidad 3))
	(jarra (capacidad 4))
)

; Llena jarra
(defrule llena-jarra
	(declare (salience 3))
	?jarra <- (jarra (capacidad ?c) (litros ?l))
	(test (< ?l ?c))
	=>
	(modify ?jarra (litros ?c))
)

; Vacia jarra
(defrule vaciar-jarra
	?jarra <- (jarra (litros ?l))
	(test (> ?l 0))
	=>
	(modify ?jarra (litros 0))
)

; Vuelca el contenido de una jarra en la otra: jarra1 -> jarra2
(defrule volcar-jarra
	(declare (salience 5))
	?jarra1 <- (jarra (litros ?l1))
	(test (>= ?l1 1))
	?jarra2 <- (jarra (litros ?l2) (capacidad ?c2))
	(test (neq ?jarra1 ?jarra2))
	(test (<= (+ ?l1 ?l2) ?c2))
	=>
	(modify ?jarra1 (litros 0))
	(modify ?jarra2 (litros (+ ?l1 ?l2)))
)

; Vuelca todo lo que quepa de una jarra en la otra: jarra1 -> jarra2
(defrule verter-jarra
				(declare (salience 4))
        ?jarra1 <- (jarra (litros ?l1))
        ?jarra2 <- (jarra (litros ?l2) (capacidad ?c2))
        (test (neq ?jarra1 ?jarra2))
        (test (> (+ ?l1 ?l2) ?c2))
        =>
        (modify ?jarra1 (litros (- ?l1 (- ?c2 ?l2))))
        (modify ?jarra2 (litros ?c2))
)




; Regla adicional
(defrule dos-litros
        (declare (salience 90))
        ?jarra <- (jarra (litros 0) (capacidad 4))
        =>
        (modify ?jarra (litros 2))
)





; Comprueba terminacion
(defrule acabar
        (declare (salience 1000))
        ?jarra <- (jarra (capacidad 4) (litros 2))
        =>
        (printout t "Lo he conseguido" crlf)
        (halt)
)
