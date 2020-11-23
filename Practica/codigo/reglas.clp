; Reglas

; saludo y explicacion ---------------------------------------------------------

(defrule saludar
  ?flag <- (juego ?juego)
  (object (is-a JUEGO) (id ?juego) (explicacion ?e) (turno-inicial ?t))
  (object (is-a PACIENTE) (nombre ?n))
  =>
  (retract ?flag)
  (assert (flag ?juego))
  (set-strategy random)
  (printout t "¡Hola " ?n "!" crlf)
)


(defrule explicar
  ?flag <- (flag ?juego)
  (object (is-a JUEGO) (id ?juego) (explicacion ?e) (turno-inicial ?t))
  =>
  (retract ?flag)
  (assert (flag comprendido))
  (make-instance of CONTROL (turno ?t) (juego ?juego))
  (printout t ?e crlf)
)


(defrule comprobar-enterado
  (declare (salience 1))
  ?flag <- (flag comprendido)
  =>
  (retract ?flag)
  (printout t "Veo que te has enterado de mi explicación. ¡Empecemos!" crlf)
)

(defrule comprobar-enterado-despistado
  (declare (salience 1))
  ?control <- (object (is-a CONTROL) (juego ?juego))
  ?flag <- (flag comprendido)
  (object (is-a PACIENTE) (personalidad despistado))
  =>
  (retract ?flag)
  (unmake-instance ?control)
  (assert (flag ?juego))
  (printout t "Veo que no te has enterado de mi explicación. Te la explico otra vez." crlf)
)

; flujo twister ----------------------------------------------------------------

(defrule robot-selecciona
  ?control <- (object (is-a CONTROL) (turno robot) (contador-ciclos ?c) (ciclos-maximos ?max) (juego twister))
  (test (< ?c ?max))
  (object (is-a COLOR) (id ?col))
  (object (is-a EXTREMIDAD) (id ?extre))
  =>
  (make-instance of ELECCION (color ?col) (extremidad ?extre))
  (modify-instance ?control (turno paciente))
  (printout t "Coloca " ?extre " en el color " ?col crlf)
)

(defrule comprobar-posicion-despistado
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (juego twister))
  ?eleccion <- (object (is-a ELECCION) (color ?col) (extremidad ?extre))
  (object (is-a PACIENTE) (personalidad despistado))
  =>
  (printout t "Veo que no has hecho el movimiento todavía. No pasa nada, te lo repito." crlf)
  (printout t "Coloca " ?extre " en el color " ?col crlf)
)


(defrule comprobar-posicion
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (juego twister))
  ?eleccion <- (object (is-a ELECCION))
  =>
  (modify-instance ?control (turno robot) (contador-ciclos (+ ?c 1)))
  (unmake-instance ?eleccion)
  (printout t "Muy bien hecho" crlf)
)

(defrule comprobar-caida
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (juego twister))
  (test (> ?c 3))
  =>
  (assert (flag terminado))
  (printout t "Oh vaya, te has caído" crlf)
)


(defrule terminar-juego
  ?control <- (object (is-a CONTROL) (contador-ciclos ?max) (ciclos-maximos ?max) (juego twister))
  =>
  (assert (flag terminado))
  (printout t "Hemos terminado el juego" crlf)
)

; Simular colocar tres-en-raya -------------------------------------------------

(defrule simular-colocar
  ?control <- (object (is-a CONTROL) (turno ?t) (contador-ciclos ?c) (juego tres-en-raya))
  ?casilla <- (object (is-a CASILLA) (x ?x) (y ?y) (valor vacio))
  (test (neq ?t comprobar))
  =>
  (modify-instance ?casilla (valor ?t))
  (modify-instance ?control (turno comprobar) (contador-ciclos (+ ?c 1)))
  (printout t "'El " ?t " ha colocado en " ?x "-" ?y "'" crlf)
)

; Condiciones de victoria ------------------------------------------------------
; Tienen prioridad para que se haga sobre el empate

(defrule comprobar-victoria-h
  (declare (salience 1))
  (object (is-a CONTROL) (turno comprobar) (juego tres-en-raya))
  (object (is-a CASILLA) (x ?x) (y 1) (valor ?v))
  (object (is-a CASILLA) (x ?x) (y 2) (valor ?v))
  (object (is-a CASILLA) (x ?x) (y 3) (valor ?v))
  (test (neq ?v vacio))
  =>
  (assert (flag terminado))
  (printout t "Ha ganado " ?v crlf)
)

(defrule comprobar-victoria-paciente-v
  (declare (salience 1))
  (object (is-a CONTROL) (turno comprobar) (juego tres-en-raya))
  (object (is-a CASILLA) (x 1) (y ?y) (valor ?v))
  (object (is-a CASILLA) (x 2) (y ?y) (valor ?v))
  (object (is-a CASILLA) (x 3) (y ?y) (valor ?v))
  (test (neq ?v vacio))
  =>
  (assert (flag terminado))
  (printout t "Ha ganado " ?v crlf)
)

(defrule comprobar-victoria-paciente-d1
  (declare (salience 1))
  (object (is-a CONTROL) (turno comprobar) (juego tres-en-raya))
  (object (is-a CASILLA) (x 1) (y 1) (valor ?v))
  (object (is-a CASILLA) (x 2) (y 2) (valor ?v))
  (object (is-a CASILLA) (x 3) (y 3) (valor ?v))
  (test (neq ?v vacio))
  =>
  (assert (flag terminado))
  (printout t "Ha ganado " ?v crlf)
)

(defrule comprobar-victoria-paciente-d2
  (declare (salience 1))
  (object (is-a CONTROL) (turno comprobar) (juego tres-en-raya))
  (object (is-a CASILLA) (x 1) (y 3) (valor ?v))
  (object (is-a CASILLA) (x 2) (y 2) (valor ?v))
  (object (is-a CASILLA) (x 3) (y 1) (valor ?v))
  (test (neq ?v vacio))
  =>
  (assert (flag terminado))
  (printout t "Ha ganado " ?v crlf)
)

; Empate -----------------------------------------------------------------------

(defrule comprobar-empate
  (object (is-a CONTROL) (turno comprobar) (juego tres-en-raya))
  (not (object (is-a CASILLA) (valor vacio)))
  =>
  (assert (flag terminado))
  (printout t "Hemos empatado" crlf)
)

; Decidir a quien le toca colocar ----------------------------------------------

(defrule decidir-siguiente-robot
  ?control <- (object (is-a CONTROL) (turno comprobar) (contador-ciclos ?c) (juego tres-en-raya))
  (object (is-a CASILLA) (valor vacio))
  (test (eq (mod ?c 2) 1))
  =>
  (modify-instance ?control (turno robot))
  (printout t "Me toca a mi" crlf)
)

(defrule decidir-siguiente-paciente
  ?control <- (object (is-a CONTROL) (turno comprobar) (contador-ciclos ?c) (juego tres-en-raya))
  (object (is-a CASILLA) (valor vacio))
  (test (eq (mod ?c 2) 0))
  =>
  (modify-instance ?control (turno paciente))
  (printout t "Te toca a ti" crlf)
)

(defrule despedirse
  (declare (salience 5))
  (object (is-a PACIENTE) (nombre ?n))
  (flag terminado)
  =>
  (printout t "¡Adios " ?n "!" crlf)
  (halt)
)
