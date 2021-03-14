
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

(defclass ACTPERS (is-a USER) ;Adicional para hacer el match entre las dos clases
        (slot nombre
                (type SYMBOL))
        (slot nombre-actividad
                (type SYMBOL))
        (slot num-actividades
                (type INTEGER)
                (default 1))
        (slot duracion-actividad
                (type INTEGER))
)       

(definstances personas
        (of PERSONA (nombre Juan) (ciudad Paris))
        (of PERSONA (nombre Ana) (ciudad Edimburgo))
)

(definstances actividades
        (of ACTIVIDAD (nombre Torre_Eiffel) (ciudad Paris) (duracion 2))
        (of ACTIVIDAD (nombre Castillo_de_Edimburgo) (ciudad Edimburgo) (duracion 5))
        (of ACTIVIDAD (nombre Louvre) (ciudad Paris) (duracion 6))
        (of ACTIVIDAD (nombre Montmartre) (ciudad Paris) (duracion 1))
        (of ACTIVIDAD (nombre Royal_Mile) (ciudad Edimburgo) (duracion 3))
)

;Crea una lista de las actividades que ha hecho cada persona y su duracion
(defrule persona-actividad
        (declare (salience 10)) ;Para que primero se haga esta regla
        (object (is-a PERSONA) (nombre ?n) (ciudad ?c))
        (object (is-a ACTIVIDAD) (ciudad ?c) (nombre ?act) (duracion ?d))
        =>
        (make-instance of ACTPERS (nombre ?n) (nombre-actividad ?act) (duracion-actividad ?d))
        (printout t "La persona " ?n " ha realizado la actividad " ?act " de duración " ?d crlf)
)

;Vamos haciendo la cuenta
(defrule suma-actividad
        (declare (salience 5))
        ?pers <- (object (is-a ACTPERS) (nombre ?n) (nombre-actividad ?act) (duracion-actividad ?c) (num-actividades ?a))
        ?pers2 <- (object (is-a ACTPERS) (nombre ?n) (nombre-actividad ?act2) (duracion-actividad ?c1))
        (test (neq ?act ?act2)) ;Cuidado que no sea la misma actividad
        =>
        (modify-instance ?pers (num-actividades (+ ?a 1)) (duracion-actividad (+ ?c ?c1)))
        (unmake-instance ?pers2)
        (printout t "--->La persona " ?n " lleva una duración total de " (+ ?c ?c1) " con " (+ ?a 1) " actividades" crlf)
)

;En caso de que las actividades fuesen impares se agrupan correctamente, eligiendo
(defrule eliminar-impares
        ?pers <- (object (is-a ACTPERS) (nombre ?n) (num-actividades ?a))
        ?pers2 <- (object (is-a ACTPERS) (nombre ?n) (num-actividades ?a1))
        (test (< ?a ?a1)) 
        =>
        (unmake-instance ?pers)
)

;Media
(defrule calcular-media
        (object (is-a ACTPERS) (nombre ?n) (num-actividades ?a) (duracion-actividad ?d))
        =>
        (printout t "La duración media de las actividades de " ?n " fue " (/ ?d ?a) crlf)
)