; Reglas

; saludo, explicación, comprobar-enterado, comprobar-enterado-despistado--------

(defrule saludar
  ?flag <- (juego ?juego)
  (object (is-a JUEGO) (id ?juego) (explicacion ?e) (turno-inicial ?t))
  (object (is-a PACIENTE) (nombre ?n))
  =>
  (retract ?flag)
  (assert (flag ?juego))
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

; Regla exclusiva para repetir si es despistado
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

; Flujo TWISTER ----------------------------------------------------------------

(defrule robot-selecciona
  ?control <- (object (is-a CONTROL) (turno robot) (contador-ciclos ?c) (ciclos-maximos ?max) (juego twister))
  (test (< ?c ?max))
  (object (is-a COLOR) (id ?col))
  (object (is-a EXTREMIDAD) (id ?extre))
  =>
  (make-instance of ELECCION (color ?col) (extremidad ?extre) (orden ?c))
  (modify-instance ?control (turno paciente))
  (printout t "Coloca " ?extre " en el color " ?col crlf)
)

; Reglas exclusivas despistado ------------------

(defrule comprobar-posicion-despistado
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (contador-fallos ?f) (juego twister))
  ?eleccion <- (object (is-a ELECCION) (color ?col) (extremidad ?extre) (repeticiones ?r) (orden ?c))
  (object (is-a PACIENTE) (personalidad despistado))
  =>
  (modify-instance ?eleccion (repeticiones (+ ?r 1)))
  (modify-instance ?control (contador-fallos (+ ?f 1)))
  (printout t "Veo que no has hecho el movimiento todavía. No pasa nada, te lo repito." crlf)
  (printout t "Coloca " ?extre " en el color " ?col crlf)
)

(defrule saltar-ciclo
  (declare (salience 1))
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (juego twister))
  ?eleccion <- (object (is-a ELECCION) (color ?col) (extremidad ?extre) (repeticiones ?r) (orden ?c))
  (test (> ?r 2))
  =>
  (modify-instance ?control (turno robot))
  (unmake-instance ?eleccion)
  (printout t "No te preocupes, vamos a pasar al siguiente movimiento" crlf)
)

; Reglas exclusivas enérgico ------------------

(defrule comprobar-posicion-energico
  (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (juego twister))
  (object (is-a ELECCION) (orden ?c))
  (object (is-a PACIENTE) (personalidad energico))
  =>
  (assert (orden-repe 0))
  (printout t "Veo que te has movido. No pasa nada, te repito todos los movimientos." crlf)
)

(defrule repetir-orden
  (declare (salience 1))
  (object (is-a CONTROL) (contador-ciclos ?c) (juego twister))
  (object (is-a ELECCION) (color ?col) (extremidad ?extre) (orden ?o))
  ?orden <- (orden-repe ?o)
  (test (< ?o (+ ?c 1)))
  =>
  (retract ?orden)
  (assert (orden-repe (+ ?o 1)))
  (printout t  ?o ": " ?extre " en " ?col crlf)
)

(defrule auxiliar-repeticion
  (declare (salience 1))
  (object (is-a CONTROL) (contador-ciclos ?c) (juego twister))
  ?orden <- (orden-repe ?o)
  (test (= ?o (+ ?c 1)))
  =>
  (retract ?orden)
  (printout t "Sigamos" crlf)
)

; Reglas normales ----------------------------

(defrule comprobar-posicion
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (juego twister))
  ?eleccion <- (object (is-a ELECCION) (orden ?c))
  =>
  (modify-instance ?control (turno robot) (contador-ciclos (+ ?c 1)))
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

; Flujo TRES-EN-RAYA------------------------------------------------------------

; Simular colocar tres-en-raya
(defrule simular-colocar
  ?control <- (object (is-a CONTROL) (turno ?t) (contador-ciclos ?c) (juego tres-en-raya))
  ?casilla <- (object (is-a CASILLA) (x ?x) (y ?y) (valor vacio))
  (test (neq ?t comprobar))
  =>
  (modify-instance ?casilla (valor ?t))
  (modify-instance ?control (turno comprobar) (contador-ciclos (+ ?c 1)))
  (printout t "'El " ?t " ha colocado en " ?x "-" ?y "'" crlf)
)

; Exclusivas enérgico --------------------

(defrule simular-coloca-mal
  ?control <- (object (is-a CONTROL) (turno robot) (contador-ciclos ?c) (contador-fallos ?f) (juego tres-en-raya))
  ?casilla <- (object (is-a CASILLA) (x ?x) (y ?y) (valor vacio))
  (object (is-a PACIENTE) (personalidad energico))
  =>
  (modify-instance ?control (contador-fallos (+ ?f 1)))
  (printout t "No puedes colocar en "  ?x "-" ?y " porque es mi turno" crlf)
)


; Exclusivas despistado --------------------

(defrule simular-no-colocar
  ?control <- (object (is-a CONTROL) (turno paciente) (contador-ciclos ?c) (contador-fallos ?f) (juego tres-en-raya))
  (object (is-a PACIENTE) (personalidad despistado))
  (object (is-a CASILLA) (x 3) (valor vacio)) ;Igualar la proporcion de despistado respecto a colocacion normal
  =>
  (modify-instance ?control (contador-fallos (+ ?f 1)))
  (printout t "Psst, te toca a ti" crlf)
)

; Condiciones de victoria -----------------
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

(defrule comprobar-victoria-v
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

(defrule comprobar-victoria-d1
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

(defrule comprobar-victoria-d2
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

; Empate -------------------------------

(defrule comprobar-empate
  (object (is-a CONTROL) (turno comprobar) (juego tres-en-raya))
  (not (object (is-a CASILLA) (valor vacio)))
  =>
  (assert (flag terminado))
  (printout t "Hemos empatado" crlf)
)

; Decidir a quien le toca colocar -------

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


; Terminar la sesión porque se equivoca más de 6 veces

(defrule demasiadas-equivocaciones-despistado
  (declare (salience 2))
  ?control <- (object (is-a CONTROL) (contador-fallos ?f))
  (test (> ?f 5))
  =>
  (assert (flag terminado))
  (printout t "Hoy no estás muy atento. Vamos a terminar la sesión." crlf)
)

(defrule demasiadas-equivocaciones-energetico
  (declare (salience 2))
  ?control <- (object (is-a CONTROL) (contador-fallos ?f))
  (object (is-a PACIENTE) (personalidad energico))
  (test (> ?f 3))
  =>
  (assert (flag terminado))
  (printout t "Estás haciendo muchas trampas. Pierdes la partida" crlf)
)


; Repetir partida exclusivo de energético --------------------------------------

(defrule repetir-partida
  (declare (salience 5))
  ?control <- (object (is-a CONTROL) (juego ?juego) (repeticiones-partida ?r))
  (object (is-a JUEGO) (id ?juego) (turno-inicial ?t))
  (object (is-a PACIENTE) (personalidad energico))
  ?flag <- (flag terminado)
  (test (< ?r 3))
  =>
  (retract ?flag)
  (assert (flag resetear))
  (unmake-instance ?control)
  (make-instance of CONTROL (turno ?t) (juego ?juego) (repeticiones-partida (+ ?r 1)))
  (printout t "Veo que todavía te quedan energías. ¡Vamos ha echar otra partida!" crlf)
)

; Resetear tres-en-raya
(defrule resetear-partida-tres-en-raya
  (declare (salience 5))
  (flag resetear)
  ?casilla <- (object (is-a CASILLA) (valor ?v))
  (test (neq ?v vacio))
  =>
  (modify-instance ?casilla (valor vacio))
  (printout t "'Reiniciando partida...'" crlf)
)


; Resetear twister
(defrule resetear-partida-twister
  (declare (salience 5))
  (flag resetear)
  ?eleccion <- (object (is-a ELECCION))
  =>
  (unmake-instance ?eleccion)
  (printout t "'Reiniciando partida...'" crlf)
)

(defrule auxiliar-fin-reseteo
  (declare (salience 4))
  ?flag <- (flag resetear)
  =>
  (retract ?flag)
  (printout t "'Partida reiniciada'" crlf)
)

; despedida --------------------------------------------------------------------

(defrule despedirse
  (declare (salience 5))
  (object (is-a PACIENTE) (nombre ?n))
  (flag terminado)
  =>
  (printout t "¡Adios " ?n "!" crlf)
  (halt)
)
