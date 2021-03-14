(defclass PERSONA (is-a INITIAL-OBJECT)
	(slot nombre
		(type SYMBOL))
	(slot ciudad
		(type SYMBOL))	
)

(defclass ACTIVIDAD (is-a INITIAL-OBJECT)
	(slot nombre
		(type SYMBOL))
	(slot ciudad
		(type SYMBOL))	
	(slot duracion
		(type INTEGER))	
)

(defclass ACTIVIDAD-PERSONA (is-a USER)
	(slot nombre
                (type SYMBOL))
        (slot nombre-act
                (type SYMBOL))
	(slot num-act
		(type INTEGER)
		(default 1))
	(slot num-horas
		(type INTEGER))		
)



(definstances personas
	(of PERSONA (nombre Juan) (ciudad Paris))
	(of PERSONA (nombre Ana) (ciudad Edimburgo)))

(definstances actividades
	(of ACTIVIDAD (nombre Torre_Eiffel) (ciudad Paris) (duracion 2))
	(of ACTIVIDAD (nombre Castillo_de_Edimburgo) (ciudad Edimburgo) (duracion 5))
	(of ACTIVIDAD (nombre Louvre) (ciudad Paris) (duracion 6))
	(of ACTIVIDAD (nombre Montmartre) (ciudad Paris) (duracion 1))
	(of ACTIVIDAD (nombre Royal_Mile) (ciudad Edimburgo) (duracion 3)))
	
	
	
(defrule add-act-pers
	(declare (salience 30))
	(object (is-a PERSONA) (nombre ?n) (ciudad ?c))
	(object (is-a ACTIVIDAD) (nombre ?a) (ciudad ?c) (duracion ?d))
	=>
	(make-instance of ACTIVIDAD-PERSONA (nombre ?n) (nombre-act ?a) (num-horas ?d))
)


(defrule add-activity
	(declare (salience 20))
	?p1 <- (object (is-a ACTIVIDAD-PERSONA) (nombre ?n) (nombre-act ?a) (num-act ?i) (num-horas ?d))
	?p2 <- (object (is-a ACTIVIDAD-PERSONA) (nombre ?n) (nombre-act ?a2) (num-horas ?d2))
	(test (neq ?a ?a2))
	=>
	(modify-instance ?p1 (num-act (+ ?i 1)) (num-horas (+ ?d ?d2)))
	(unmake-instance ?p2)
)


(defrule parada
	(declare (salience 10))
	?p1 <- (object (is-a ACTIVIDAD-PERSONA) (nombre ?n) (nombre-act ?a) (num-act ?i) (num-horas ?d))
	(test (> ?i 0))
	=>
	(printout t "La duración media de las actividades de " ?n " fue " (/ ?d ?i) crlf)
	(unmake-instance ?p1)
)
		
