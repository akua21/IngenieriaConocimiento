; PROBLEMA REACCIONES QUÍMICAS

;; Marco para guardar los tipos de átomos y los
;; números totales en los reactivos y productos
(defclass ATOMO (is-a USER)
  (slot id ;;símbolo del átomo
	(type SYMBOL))
  (slot total-re
	(type INTEGER)
	(default 0))
  (slot total-pr
	(type INTEGER)
	(default 0)))

;;Marco abstracto de los distintas f�rmula que componen la reacción
;;Las instancias serán de sus clases hijas REACTIVO o PRODUCTO
(defclass FORMULA (is-a USER)
  (slot id ;;identificador único de la fórmula
	(type SYMBOL))
  (slot coeficiente ;;coeficiente en la fórmula
	(type INTEGER)
	(default 1)))
(defclass REACTIVO (is-a FORMULA))
(defclass PRODUCTO (is-a FORMULA))

;;Marco para representar cada componente de las fórmulas
;;En el slot formula se guarda el identificador de la fórmula
;;al que pertenece para poder relacionarlos.
(defclass COMPONENTE (is-a USER)
  (slot formula ;id de la fórmula
	(type SYMBOL))
  (slot atomo ;;símbolo del átomo
	(type SYMBOL))
  (slot num ;;nº de átomos en la fórmula
	(type INTEGER)
	(default 1))
  (slot contado ;;para contar átomos
	(type SYMBOL)
	(default no)))

;; KClO3  ---->  KCl +  O2
;; 2KClO3  ---->  KCl + 3O2
;; 2KClO3  ----> 2KCl + 3O2
;(definstances reaccion1
;  ([k]  of ATOMO (id K))
;  ([cl] of ATOMO (id Cl))
;  ([o]  of ATOMO (id O))
;  ([r1] of REACTIVO (id KClO3))
;  ([p1] of PRODUCTO (id KCl) )
;  ([p2] of PRODUCTO (id O2))
;  ([c1r1] of COMPONENTE (formula KClO3) (atomo K))
;  ([c2r1] of COMPONENTE (formula KClO3) (atomo Cl))
;  ([c3r1] of COMPONENTE (formula KClO3) (atomo O) (num 3))
;  ([c1p1] of COMPONENTE (formula KCl) (atomo K))
;  ([c2p1] of COMPONENTE (formula KCl) (atomo Cl) )
;  ([c1p2] of COMPONENTE (formula O2) (atomo O) (num 2)))



; REACCIÓN QUE SE PIDE

;; CH4 + O2 --->  H2O + CO2
;; 2CH4 + O2 --->  4H2O + CO2
;; 2CH4 + O2 --->  4H2O + 2CO2
;; 2CH4 + 4O2 --->  4H2O + 2CO2
(definstances reaccion2
  ([c]  of ATOMO (id C))
  ([h] of ATOMO (id H))
  ([o]  of ATOMO (id O))
  ([r1] of REACTIVO (id CH4))
  ([r2] of REACTIVO (id O2))
  ([p1] of PRODUCTO (id H2O) )
  ([p2] of PRODUCTO (id CO2))
  ([c1r1] of COMPONENTE (formula CH4) (atomo C))
  ([c2r1] of COMPONENTE (formula CH4) (atomo H) (num 4))
  ([c1r2] of COMPONENTE (formula O2) (atomo O) (num 2))
  ([c1p1] of COMPONENTE (formula H2O) (atomo H) (num 2))
  ([c2p1] of COMPONENTE (formula H2O) (atomo O))
  ([c1p2] of COMPONENTE (formula CO2) (atomo C))
  ([c2p2] of COMPONENTE (formula CO2) (atomo O) (num 2)))


(defrule cuenta-re
  (not (inicializa))
  (object (is-a REACTIVO) (id ?idm) (coeficiente ?coe))
  ?C <- (object (is-a COMPONENTE) (formula ?idm)(atomo ?id) (num ?num)
		(contado no))
  ?A <- (object (is-a ATOMO) (id ?id) (total-re ?t))
  =>
  (modify-instance ?A (total-re (+ ?t (* ?coe ?num))))
  (modify-instance ?C (contado si)))

(defrule cuenta-pr
  (not (inicializa))
  (object (is-a PRODUCTO) (id ?idm)(coeficiente ?coe))
  ?C <- (object (is-a COMPONENTE) (formula ?idm) (atomo ?id) (num ?num)
		(contado no))
  ?A <- (object (is-a ATOMO) (id ?id) (total-pr ?t))
  =>
  (modify-instance ?A (total-pr (+ ?t (* ?coe ?num))))
  (modify-instance ?C (contado si)))


(defrule ajusta-coeficiente1
(declare (salience -100))
(object (is-a ATOMO) (id ?id) (total-re ?tr) (total-pr ?tp&~?tr))

?R <- (object (is-a REACTIVO) (id ?idr) (coeficiente 1))
(object (is-a COMPONENTE) (formula ?idr) (atomo ?id) (num ?numr))

?P <- (object (is-a PRODUCTO) (id ?idp) (coeficiente 1))
(object (is-a COMPONENTE) (formula ?idp) (atomo ?id) (num ?nump))
=>
(modify-instance ?R (coeficiente ?nump))
(modify-instance ?P (coeficiente ?numr))
(assert (inicializa))
)


(defrule ajusta-coeficiente2
(declare (salience -100))
(object (is-a ATOMO) (id ?id) (total-re ?tr) (total-pr ?tp&~?tr))

?R <- (object (is-a REACTIVO) (id ?idr) (coeficiente ?cr&~1))
(object (is-a COMPONENTE) (formula ?idr) (atomo ?id) (num 1))

?P <- (object (is-a PRODUCTO) (id ?idp) (coeficiente 1))
(object (is-a COMPONENTE) (formula ?idp) (atomo ?id) (num 1))
=>
(modify-instance ?P (coeficiente ?cr))
(assert (inicializa))
)


; REGLA AÑADIDA
(defrule ajusta-coeficiente3
(declare (salience -100))
(object (is-a ATOMO) (id ?id) (total-re ?tr) (total-pr ?tp&~?tr))

(test (> ?tp ?tr))
(test (neq ?tr 0))
(test (eq (mod ?tp ?tr) 0))

?R <- (object (is-a REACTIVO) (id ?idr) (coeficiente ?cr))
(object (is-a COMPONENTE) (formula ?idr) (atomo ?id) (num ?numr))

(test (eq (* ?cr ?numr) ?tr))
=>
(modify-instance ?R (coeficiente (integer (/ ?tp ?tr))))
(assert (inicializa))
)



(defrule resetea-totales
(inicializa)
?a <- (object (is-a ATOMO) (total-re ?t&~0))
=>
(modify-instance ?a (total-re 0) (total-pr 0))
)
(defrule resetea-componentes
(inicializa)
?a <- (object (is-a COMPONENTE) (contado si))
=>
(modify-instance ?a (contado no))
)
(defrule quitar-inicializa
?f1<- (inicializa)
(not (object (is-a ATOMO) (total-re ?x&~0)))
(not (object (is-a COMPONENTE) (contado si)))
=>
(retract ?f1))


; Ejecución (watch rules)

; FIRE    1 cuenta-pr: *,[p2],[c2p2],[o]
; FIRE    2 cuenta-pr: *,[p1],[c2p1],[o]
; FIRE    3 cuenta-pr: *,[p2],[c1p2],[c]
; FIRE    4 cuenta-pr: *,[p1],[c1p1],[h]
; FIRE    5 cuenta-re: *,[r2],[c1r2],[o]
; FIRE    6 cuenta-re: *,[r1],[c2r1],[h]
; FIRE    7 cuenta-re: *,[r1],[c1r1],[c]
; FIRE    8 ajusta-coeficiente1: [h],[r1],[c2r1],[p1],[c1p1]
; FIRE    9 resetea-totales: f-1,[c]
; FIRE   10 resetea-totales: f-1,[h]
; FIRE   11 resetea-totales: f-1,[o]
; FIRE   12 resetea-componentes: f-1,[c1r1]
; FIRE   13 resetea-componentes: f-1,[c2r1]
; FIRE   14 resetea-componentes: f-1,[c1r2]
; FIRE   15 resetea-componentes: f-1,[c1p1]
; FIRE   16 resetea-componentes: f-1,[c1p2]
; FIRE   17 resetea-componentes: f-1,[c2p1]
; FIRE   18 resetea-componentes: f-1,[c2p2]
; FIRE   19 quitar-inicializa: f-1,*,*
; FIRE   20 cuenta-re: *,[r1],[c2r1],[h]
; FIRE   21 cuenta-re: *,[r1],[c1r1],[c]
; FIRE   22 cuenta-re: *,[r2],[c1r2],[o]
; FIRE   23 cuenta-pr: *,[p1],[c2p1],[o]
; FIRE   24 cuenta-pr: *,[p2],[c2p2],[o]
; FIRE   25 cuenta-pr: *,[p1],[c1p1],[h]
; FIRE   26 cuenta-pr: *,[p2],[c1p2],[c]
; FIRE   27 ajusta-coeficiente2: [c],[r1],[c1r1],[p2],[c1p2]
; FIRE   28 resetea-totales: f-2,[o]
; FIRE   29 resetea-totales: f-2,[c]
; FIRE   30 resetea-totales: f-2,[h]
; FIRE   31 resetea-componentes: f-2,[c1p2]
; FIRE   32 resetea-componentes: f-2,[c1p1]
; FIRE   33 resetea-componentes: f-2,[c2p2]
; FIRE   34 resetea-componentes: f-2,[c2p1]
; FIRE   35 resetea-componentes: f-2,[c1r2]
; FIRE   36 resetea-componentes: f-2,[c1r1]
; FIRE   37 resetea-componentes: f-2,[c2r1]
; FIRE   38 quitar-inicializa: f-2,*,*
; FIRE   39 cuenta-re: *,[r1],[c2r1],[h]
; FIRE   40 cuenta-re: *,[r1],[c1r1],[c]
; FIRE   41 cuenta-re: *,[r2],[c1r2],[o]
; FIRE   42 cuenta-pr: *,[p2],[c2p2],[o]
; FIRE   43 cuenta-pr: *,[p1],[c2p1],[o]
; FIRE   44 cuenta-pr: *,[p2],[c1p2],[c]
; FIRE   45 cuenta-pr: *,[p1],[c1p1],[h]
; FIRE   46 ajusta-coeficiente3: [o],[r2],[c1r2]
; FIRE   47 resetea-totales: f-3,[o]
; FIRE   48 resetea-totales: f-3,[c]
; FIRE   49 resetea-totales: f-3,[h]
; FIRE   50 resetea-componentes: f-3,[c1p1]
; FIRE   51 resetea-componentes: f-3,[c1p2]
; FIRE   52 resetea-componentes: f-3,[c2p1]
; FIRE   53 resetea-componentes: f-3,[c2p2]
; FIRE   54 resetea-componentes: f-3,[c1r2]
; FIRE   55 resetea-componentes: f-3,[c1r1]
; FIRE   56 resetea-componentes: f-3,[c2r1]
; FIRE   57 quitar-inicializa: f-3,*,*
; FIRE   58 cuenta-re: *,[r2],[c1r2],[o]
; FIRE   59 cuenta-re: *,[r1],[c2r1],[h]
; FIRE   60 cuenta-re: *,[r1],[c1r1],[c]
; FIRE   61 cuenta-pr: *,[p2],[c2p2],[o]
; FIRE   62 cuenta-pr: *,[p1],[c2p1],[o]
; FIRE   63 cuenta-pr: *,[p2],[c1p2],[c]
; FIRE   64 cuenta-pr: *,[p1],[c1p1],[h]
