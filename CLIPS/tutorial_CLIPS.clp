(deftemplate jarra
  (slot litros
    (type INTEGER)
    (default 0)))

(defrule estado-inicial
  =>
  (assert (jarra)))

(defrule un-litro-mas
  ?jarra <- (jarra (litros ?l))
  =>
  (modify ?jarra (litros (+ ?l 1))))

(defrule dos-litros-mas
  ?jarra <- (jarra (litros ?l))
  =>
  (modify ?jarra (litros (+ ?l 2))))

(defrule acabar
  (declare (salience 1000))
  ?jarra <- (jarra (litros 3))
  =>
  (printout t "Lo he conseguido" crlf)
  (retract ?jarra))
