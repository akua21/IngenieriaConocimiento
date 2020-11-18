; Reglas

(defrule realizar-accion
  ?accion <- (object (is-a ACCION) (nombre ?actual))
  (object (is-a FLUJO) (accion-actual ?actual) (accion-resultante ?result) (imprimir ?pr))
  =>
  (unmake-instance ?accion)
  (make-instance of ACCION (nombre ?result))
  (printout t ?pr crlf)
)

(defrule elegir-extremidad-color
  (declare (salience 1))
  ?accion <- (object (is-a ACCION) (nombre elegir))
  (object (is-a FLUJO-TWISTER) (accion-actual elegir) (accion-resultante ?result))
  (extremidad ?extre)
  (color ?color)
  ?tw <- (object (is-a TWISTER))
  =>
  (unmake-instance ?accion)
  (make-instance of ACCION (nombre ?result))
  (modify-instance ?tw (color-indicado ?color) (extremidad-indicada ?extre))
  (printout t "Colocar " ?extre " en el color " ?color crlf)
)


(defrule comprobar-correcto
  (declare (salience 1))
  ?accion <- (object (is-a ACCION) (nombre comprobar-bien))
  (object (is-a FLUJO-TWISTER) (accion-actual comprobar-bien) (accion-resultante ?result) (imprimir ?pr))
  ?estado <- (object (is-a ESTADO) (num-acciones ?num) (acciones-max ?max))
  (test (< ?num ?max))
  =>
  (unmake-instance ?accion)
  (make-instance of ACCION (nombre ?result))
  (modify-instance ?estado (num-acciones (+ ?num 1)))
  (printout t ?pr crlf)
)

(defrule terminar-juego
  (declare (salience 2))
  ?accion <- (object (is-a ACCION) (nombre comprobar-bien))
  ?estado <- (object (is-a ESTADO) (num-acciones ?max) (acciones-max ?max))
  =>
  (unmake-instance ?accion)
  (make-instance of ACCION (nombre terminar-juego))
  (printout t "Bien jugado" crlf)
)

(defrule fin-sesion
  (declare (salience 10))
  ?accion <- (object (is-a ACCION) (nombre apagar-robot))
  =>
  (printout t "Robot apagado" crlf)
  (halt)
)
