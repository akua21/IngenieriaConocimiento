; PROBLEMA FÁBRICA DE CERVEZA

; Clases
(defclass ACTIVIDAD (is-a USER)
	(slot recurso
		(type STRING))
	(slot entrada
		(type STRING))
	(slot salida
		(type STRING))
	(slot tiempo
		(type INTEGER))
)

(defclass ACTIVIDAD-1-E (is-a ACTIVIDAD))

(defclass ACTIVIDAD-2-E (is-a ACTIVIDAD)
	(slot entrada-2
		(type STRING))
)

(defclass RECURSO (is-a USER)
	(slot nombre
		(type STRING))
	(slot estado
		(type SYMBOL)
		(allowed-values on off)
		(default on))
)

(defclass PRODUCTO (is-a USER)
	(slot nombre
		(type STRING))
	(slot tipo
		(type SYMBOL)
		(allowed-values materia-prima elaborado))
)

; Instancias
(definstances init
	([lam-vid] of PRODUCTO (nombre lamina-vidrio) (tipo materia-prima))
	([cha-hoj] of PRODUCTO (nombre chapa-hojalata) (tipo materia-prima))
	([cerv] of PRODUCTO (nombre cerveza) (tipo materia-prima))
	([fund] of RECURSO (nombre fundidora))
	([mold] of RECURSO (nombre molde))
	([relle] of RECURSO (nombre rellenadora))
	([cort] of RECURSO (nombre cortadora))
	([pren] of RECURSO (nombre prensa))
	([tapa] of RECURSO (nombre tapadora))
	([a-fund] of ACTIVIDAD-1-E (recurso fundidora) (entrada lamina-vidrio) (salida vidrio-fundido) (tiempo 10))
	([a-mold] of ACTIVIDAD-1-E (recurso molde) (entrada vidrio-fundido) (salida botella) (tiempo 5))
	([a-relle] of ACTIVIDAD-2-E (recurso rellenadora) (entrada botella) (entrada-2 cerveza) (salida botella-rellena) (tiempo 2))
	([a-cort] of ACTIVIDAD-1-E (recurso cortadora) (entrada chapa-hojalata) (salida trozo-circular) (tiempo 2))
	([a-pren] of ACTIVIDAD-1-E (recurso prensa) (entrada trozo-circular) (salida tapon) (tiempo 3))
	([a-tapa] of ACTIVIDAD-2-E (recurso tapadora) (entrada botella-rellena) (entrada-2 tapon) (salida producto-final) (tiempo 1))
)

; Facts
(deffacts facts
	(tiempo-total 0)
)


;Reglas
(defrule r-ACTIVIDAD-1-E
	(object (is-a ACTIVIDAD-1-E) (recurso ?r) (entrada ?e) (salida ?s) (tiempo ?t))
	(object (is-a RECURSO) (nombre ?r) (estado on))
	?prod <- (object (is-a PRODUCTO) (nombre ?e) (tipo ?tp))
	?tiempo <- (tiempo-total ?tt)
	=>
	(unmake-instance ?prod)
	(make-instance of PRODUCTO (nombre ?s) (tipo elaborado))
	(retract ?tiempo)
	(assert (tiempo-total (+ ?tt ?t)))
	(printout t "A partir del producto " ?e " de tipo " ?tp " se ha creado el producto " ?s " con el recurso " ?r " en un tiempo de " ?t crlf)
	(printout t "El tiempo total acumulado es de " (+ ?tt ?t) crlf)
)


(defrule r-ACTIVIDAD-2-E
	(object (is-a ACTIVIDAD-2-E) (recurso ?r) (entrada ?e) (entrada-2 ?e2) (salida ?s) (tiempo ?t))
	(object (is-a RECURSO) (nombre ?r) (estado on))
	?prod1 <- (object (is-a PRODUCTO) (nombre ?e) (tipo ?tp))
	?prod2 <- (object (is-a PRODUCTO) (nombre ?e2) (tipo ?tp2))
	?tiempo <- (tiempo-total ?tt)
	=>
	(unmake-instance ?prod1 ?prod2)
	(make-instance of PRODUCTO (nombre ?s) (tipo elaborado))
	(retract ?tiempo)
	(assert (tiempo-total (+ ?tt ?t)))
	(printout t "A partir de los productos " ?e " de tipo " ?tp " y " ?e2 " de tipo " ?tp2" se ha creado el producto " ?s " con el recurso " ?r " en un tiempo de " ?t crlf)
	(printout t "El tiempo total acumulado es de " (+ ?tt ?t) crlf)
)

(defrule fin
	(declare (salience 10))
	(object (is-a PRODUCTO) (nombre ?n))
	(test (eq ?n producto-final))
	(tiempo-total ?tt)
	=>
	(printout t "Se ha obtenido el producto final en un tiempo de " ?tt crlf)
	(halt)
)


; Ejecución
; FIRE    1 r-ACTIVIDAD-1-E: [a-fund],[fund],[lam-vid],f-1
; A partir del producto lamina-vidrio de tipo materia-prima se ha creado el producto vidrio-fundido con el recurso fundidora en un tiempo de 10
; El tiempo total acumulado es de 10
; FIRE    2 r-ACTIVIDAD-1-E: [a-cort],[cort],[cha-hoj],f-2
; A partir del producto chapa-hojalata de tipo materia-prima se ha creado el producto trozo-circular con el recurso cortadora en un tiempo de 2
; El tiempo total acumulado es de 12
; FIRE    3 r-ACTIVIDAD-1-E: [a-mold],[mold],[gen7],f-3
; A partir del producto vidrio-fundido de tipo elaborado se ha creado el producto botella con el recurso molde en un tiempo de 5
; El tiempo total acumulado es de 17
; FIRE    4 r-ACTIVIDAD-1-E: [a-pren],[pren],[gen8],f-4
; A partir del producto trozo-circular de tipo elaborado se ha creado el producto tapon con el recurso prensa en un tiempo de 3
; El tiempo total acumulado es de 20
; FIRE    5 r-ACTIVIDAD-2-E: [a-relle],[relle],[gen9],[cerv],f-5
; A partir de los productos botella de tipo elaborado y cerveza de tipo materia-prima se ha creado el producto botella-rellena con el recurso rellenadora en un tiempo de 2
; El tiempo total acumulado es de 22
; FIRE    6 r-ACTIVIDAD-2-E: [a-tapa],[tapa],[gen11],[gen10],f-6
; A partir de los productos botella-rellena de tipo elaborado y tapon de tipo elaborado se ha creado el producto producto-final con el recurso tapadora en un tiempo de 1
; El tiempo total acumulado es de 23
; FIRE    7 fin: [gen12],f-7
; Se ha obtenido el producto final en un tiempo de 23
; [PRCCODE4] Execution halted during the actions of defrule fin.
