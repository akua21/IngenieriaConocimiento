(defclass COLOUR (is-a USER)
  (slot id  (type SYMBOL))
  (slot rep (type INTEGER))
  )

(defclass CHOICE (is-a USER)
   (slot num (type INTEGER) (default 1))
   (slot colour (type SYMBOL))
)

(defclass CONTROL (is-a USER)
  (slot turn (type SYMBOL) (allowed-values robot human) (default robot))
  (slot round (type INTEGER)   (default 1))
  (slot instant  (type INTEGER) (default 1))
  (slot limit (type INTEGER)   (default 5))
  (slot max-repe (type INTEGER) (default 3))
)




; Clase que representa la acción realizada
(defclass ACTION-DONE (is-a USER)
  (slot name-act (type SYMBOL))
  (slot colour (type SYMBOL))
  (slot order-act (type INTEGER))
)

; Fact para llevar el contador de las acciones que se realizan
(deffacts init
	(counter-for-order 0)
)




(definstances ini
  ([red] of COLOUR (id red))
  ([yel] of COLOUR (id yellow))
  ([gre] of COLOUR (id green))
  ([blu] of COLOUR (id blue))
  ([con] of CONTROL)
)

(defrule stop
  (declare (salience 200))
  (object (is-a CONTROL)  (turn robot) (limit ?l) (round ?r))
  (test (> ?r ?l))
=>
 (printout t "FIN rondas. Secuencia de acciones: " crlf)
 (assert (sequence-order 0))
)


; Regla para imprimir por orden la secuencia de acciones
(defrule seq-act-print
  (declare (salience 300))
  ?seq-order <-(sequence-order ?s)
  (object (is-a ACTION-DONE) (name-act ?n) (colour ?c) (order-act ?s))
  =>
    (printout t ?s "-> " ?n " -> color: " ?c crlf)
    (retract ?seq-order)
    (assert (sequence-order (+ ?s 1)))
)

; Regla FIN
(defrule final
  (declare (salience 400))
  (sequence-order ?o)
  (counter-for-order ?o)
  =>
  (halt)
)


(defrule next-round
;;  (declare (salience 100))
  ?con <- (object (is-a CONTROL) (turn human) (instant ?i) (round ?r))
  (test (> ?i ?r))
=>
 (modify-instance ?con (round (+ 1 ?r)) (instant 1) (turn robot))
)

;;Robot plays generating a new random colour
;;Last instant of the round
(defrule robot-plays-new
  ?col <- (object (is-a COLOUR) (id ?c) (rep ?re))
  ?con <- (object (is-a CONTROL) (turn robot) (instant ?r) (round ?r) (max-repe ?m))
  (test (< ?re ?m))
  ?counter <- (counter-for-order ?o)
  =>
 (make-instance of CHOICE (num ?r) (colour ?c))
 (printout t "Robot-plays-new "  ?c crlf)


 ; Se crea una instancia de ACTION-DONE y se suma uno al counter-for-order
 (make-instance of ACTION-DONE (name-act Robot-plays-new) (colour ?c) (order-act ?o))
 (retract ?counter)
 (assert (counter-for-order (+ ?o 1)))


 (modify-instance ?con (instant 1) (turn human))
 (modify-instance ?col (rep (+ 1 ?re)))
)

;;Robot plays reproducing the previous colour
(defrule robot-plays-old
  (object (is-a CHOICE) (num ?i) (colour ?c))
  ?con <- (object (is-a CONTROL) (turn robot) (instant ?i) (round ?r))
  (test (< ?i ?r))
  ?counter <- (counter-for-order ?o)
  =>
 (printout t "Robot-plays-old "  ?c crlf)


 ; Se crea una instancia de ACTION-DONE y se suma uno al counter-for-order
 (make-instance of ACTION-DONE (name-act Robot-plays-old) (colour ?c) (order-act ?o))
 (retract ?counter)
 (assert (counter-for-order (+ ?o 1)))


 (modify-instance ?con (instant (+ 1 ?i)))
)

(defrule checks-human
  ?con <- (object (is-a CONTROL) (turn human) (instant ?i) (round ?r))
  (object (is-a CHOICE) (num ?i) (colour ?co))
  (test (>= ?r ?i))
  ?counter <- (counter-for-order ?o)
  =>
 (printout t "Check-human "  ?co crlf)


 ; Se crea una instancia de ACTION-DONE y se suma uno al counter-for-order
 (make-instance of ACTION-DONE (name-act Check-human) (colour ?co) (order-act ?o))
 (retract ?counter)
 (assert (counter-for-order (+ ?o 1)))


 (modify-instance ?con (instant (+ 1 ?i)))
)




; Watch rules

; FIRE    1 robot-plays-new: [blu],[con],f-1
; Robot-plays-new blue
; FIRE    2 checks-human: [con],[gen1],f-2
; Check-human blue
; FIRE    3 next-round: [con]
; FIRE    4 robot-plays-old: [gen1],[con],f-3
; Robot-plays-old blue
; FIRE    5 robot-plays-new: [red],[con],f-4
; Robot-plays-new red
; FIRE    6 checks-human: [con],[gen1],f-5
; Check-human blue
; FIRE    7 checks-human: [con],[gen5],f-6
; Check-human red
; FIRE    8 next-round: [con]
; FIRE    9 robot-plays-old: [gen1],[con],f-7
; Robot-plays-old blue
; FIRE   10 robot-plays-old: [gen5],[con],f-8
; Robot-plays-old red
; FIRE   11 robot-plays-new: [yel],[con],f-9
; Robot-plays-new yellow
; FIRE   12 checks-human: [con],[gen1],f-10
; Check-human blue
; FIRE   13 checks-human: [con],[gen5],f-11
; Check-human red
; FIRE   14 checks-human: [con],[gen11],f-12
; Check-human yellow
; FIRE   15 next-round: [con]
; FIRE   16 robot-plays-old: [gen1],[con],f-13
; Robot-plays-old blue
; FIRE   17 robot-plays-old: [gen5],[con],f-14
; Robot-plays-old red
; FIRE   18 robot-plays-old: [gen11],[con],f-15
; Robot-plays-old yellow
; FIRE   19 robot-plays-new: [gre],[con],f-16
; Robot-plays-new green
; FIRE   20 checks-human: [con],[gen1],f-17
; Check-human blue
; FIRE   21 checks-human: [con],[gen5],f-18
; Check-human red
; FIRE   22 checks-human: [con],[gen11],f-19
; Check-human yellow
; FIRE   23 checks-human: [con],[gen19],f-20
; Check-human green
; FIRE   24 next-round: [con]
; FIRE   25 robot-plays-old: [gen1],[con],f-21
; Robot-plays-old blue
; FIRE   26 robot-plays-old: [gen5],[con],f-22
; Robot-plays-old red
; FIRE   27 robot-plays-old: [gen11],[con],f-23
; Robot-plays-old yellow
; FIRE   28 robot-plays-old: [gen19],[con],f-24
; Robot-plays-old green
; FIRE   29 robot-plays-new: [blu],[con],f-25
; Robot-plays-new blue
; FIRE   30 checks-human: [con],[gen1],f-26
; Check-human blue
; FIRE   31 checks-human: [con],[gen5],f-27
; Check-human red
; FIRE   32 checks-human: [con],[gen11],f-28
; Check-human yellow
; FIRE   33 checks-human: [con],[gen19],f-29
; Check-human green
; FIRE   34 checks-human: [con],[gen29],f-30
; Check-human blue
; FIRE   35 next-round: [con]
; FIRE   36 stop: [con]
; FIN rondas. Secuencia de acciones:
; FIRE   37 seq-act-print: f-32,[gen2]
; 0-> Robot-plays-new -> color: blue
; FIRE   38 seq-act-print: f-33,[gen3]
; 1-> Check-human -> color: blue
; FIRE   39 seq-act-print: f-34,[gen4]
; 2-> Robot-plays-old -> color: blue
; FIRE   40 seq-act-print: f-35,[gen6]
; 3-> Robot-plays-new -> color: red
; FIRE   41 seq-act-print: f-36,[gen7]
; 4-> Check-human -> color: blue
; FIRE   42 seq-act-print: f-37,[gen8]
; 5-> Check-human -> color: red
; FIRE   43 seq-act-print: f-38,[gen9]
; 6-> Robot-plays-old -> color: blue
; FIRE   44 seq-act-print: f-39,[gen10]
; 7-> Robot-plays-old -> color: red
; FIRE   45 seq-act-print: f-40,[gen12]
; 8-> Robot-plays-new -> color: yellow
; FIRE   46 seq-act-print: f-41,[gen13]
; 9-> Check-human -> color: blue
; FIRE   47 seq-act-print: f-42,[gen14]
; 10-> Check-human -> color: red
; FIRE   48 seq-act-print: f-43,[gen15]
; 11-> Check-human -> color: yellow
; FIRE   49 seq-act-print: f-44,[gen16]
; 12-> Robot-plays-old -> color: blue
; FIRE   50 seq-act-print: f-45,[gen17]
; 13-> Robot-plays-old -> color: red
; FIRE   51 seq-act-print: f-46,[gen18]
; 14-> Robot-plays-old -> color: yellow
; FIRE   52 seq-act-print: f-47,[gen20]
; 15-> Robot-plays-new -> color: green
; FIRE   53 seq-act-print: f-48,[gen21]
; 16-> Check-human -> color: blue
; FIRE   54 seq-act-print: f-49,[gen22]
; 17-> Check-human -> color: red
; FIRE   55 seq-act-print: f-50,[gen23]
; 18-> Check-human -> color: yellow
; FIRE   56 seq-act-print: f-51,[gen24]
; 19-> Check-human -> color: green
; FIRE   57 seq-act-print: f-52,[gen25]
; 20-> Robot-plays-old -> color: blue
; FIRE   58 seq-act-print: f-53,[gen26]
; 21-> Robot-plays-old -> color: red
; FIRE   59 seq-act-print: f-54,[gen27]
; 22-> Robot-plays-old -> color: yellow
; FIRE   60 seq-act-print: f-55,[gen28]
; 23-> Robot-plays-old -> color: green
; FIRE   61 seq-act-print: f-56,[gen30]
; 24-> Robot-plays-new -> color: blue
; FIRE   62 seq-act-print: f-57,[gen31]
; 25-> Check-human -> color: blue
; FIRE   63 seq-act-print: f-58,[gen32]
; 26-> Check-human -> color: red
; FIRE   64 seq-act-print: f-59,[gen33]
; 27-> Check-human -> color: yellow
; FIRE   65 seq-act-print: f-60,[gen34]
; 28-> Check-human -> color: green
; FIRE   66 seq-act-print: f-61,[gen35]
; 29-> Check-human -> color: blue
; FIRE   67 final: f-62,f-31
; [PRCCODE4] Execution halted during the actions of defrule final.
