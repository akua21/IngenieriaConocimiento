;PROBLEMA CANALES

(defclass DEPOSITO (is-a INITIAL-OBJECT)
	(slot nombre
		(type SYMBOL)
		(allowed-values A B C))
	(slot abierto
		(type SYMBOL)
		(allowed-values True False))
	(slot canal
		(type INTEGER))	
)

(defclass TUBERIA (is-a INITIAL-OBJECT)
	(slot inicio
		(type INTEGER))
	(slot fin
		(type INTEGER))
	(slot altura
		(type INTEGER))
)

(defclass AGUA (is-a USER)
	(slot altura 
		(type INTEGER))
	(slot canal 
		(type INTEGER))
)


(definstances depositos
	(of DEPOSITO (nombre A) (abierto False) (canal 1))
	(of DEPOSITO (nombre B) (abierto False) (canal 2))
	(of DEPOSITO (nombre C) (abierto True) (canal 3))
)

(definstances tuberias
	(of TUBERIA (inicio 1) (fin 2) (altura 3))
	(of TUBERIA (inicio 2) (fin 3) (altura 2))
	(of TUBERIA (inicio 3) (fin 2) (altura 1))
)



(defrule salir-agua
	(declare (salience 8))
	(object (is-a DEPOSITO) (nombre ?n) (abierto True) (canal ?c))
	=>
	(make-instance of AGUA (altura 4) (canal ?c))
)

(defrule pasar-agua-i-d
	(declare (salience 6))
	?agua <- (object (is-a AGUA) (altura ?a) (canal ?c))
	(object (is-a TUBERIA) (inicio ?c) (fin ?f) (altura ?h))
	(test (= ?a ?h))
	=>
	(modify-instance ?agua (altura (- ?h 1)) (canal ?f))
)

(defrule pasar-agua-d-i
	(declare (salience 6))
	?agua <- (object (is-a AGUA) (altura ?a) (canal ?c))
	(object (is-a TUBERIA) (inicio ?f) (fin ?c) (altura ?h))
	(test (= ?a ?h))
	=>
	(modify-instance ?agua (altura (- ?h 1)) (canal ?f))
)


(defrule bajar-canal
	(declare (salience 4))
	?agua <- (object (is-a AGUA) (altura ?a) (canal ?c))
	=>
	(modify-instance ?agua (altura (- ?a 1)))
)


(defrule parada
	(declare (salience 10))
	(object (is-a DEPOSITO) (nombre ?n) (abierto True))
	(object (is-a AGUA) (altura 0) (canal ?c))
	=>
	(printout t "El agua sale del depósito " ?n " y ha llegado al canal " ?c crlf)
	(halt)
)



;RESULTADOS

;Abrir depósito A

;FIRE    1 salir-agua: [gen15]
;FIRE    2 bajar-canal: [gen21]
;FIRE    3 pasar-agua-i-d: [gen21],[gen18]
;FIRE    4 pasar-agua-i-d: [gen21],[gen19]
;FIRE    5 pasar-agua-i-d: [gen21],[gen20]
;FIRE    6 parada: [gen15],[gen21]
;El agua sale del depósito A y ha llegado al canal 2


;Abrir depósito B

;FIRE    1 salir-agua: [gen9]
;FIRE    2 bajar-canal: [gen14]
;FIRE    3 pasar-agua-d-i: [gen14],[gen11]
;FIRE    4 bajar-canal: [gen14]
;FIRE    5 bajar-canal: [gen14]
;FIRE    6 parada: [gen9],[gen14]
;El agua sale del depósito B y ha llegado al canal 1



;Abrir depósito C

;FIRE    1 salir-agua: [gen24]
;FIRE    2 bajar-canal: [gen28]
;FIRE    3 bajar-canal: [gen28]
;FIRE    4 pasar-agua-d-i: [gen28],[gen26]
;FIRE    5 pasar-agua-d-i: [gen28],[gen27]
;FIRE    6 parada: [gen24],[gen28]
;El agua sale del depósito C y ha llegado al canal 3

