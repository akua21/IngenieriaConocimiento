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
  (modify-instance ?tw (comando (str-cat ?extre (str-cat - ?color))))
  (printout t "Colocar " ?extre " en el color " ?color crlf)
)

(defrule colocar-extremidad-color)
