; Jerarquía de clases

(defclass JUEGO (is-a INITIAL-OBJECT)
  (slot id
    (type SYMBOL)
  )

  (slot explicacion
    (type STRING)
  )

  (slot turno-inicial
    (type SYMBOL)
  )
)

(defclass CONTROL (is-a INITIAL-OBJECT)
  (slot turno
    (type SYMBOL)
  )

  (slot contador-ciclos
    (type INTEGER)
    (default 0)
  )

  (slot ciclos-maximos
    (type INTEGER)
    (default 5)
  )

  (slot contador-fallos
    (type INTEGER)
    (default 0)
  )

  (slot juego
    (type SYMBOL)
  )
)

(defclass PACIENTE (is-a INITIAL-OBJECT)
  (slot nombre
    (type STRING)
  )

  (slot personalidad
    (type SYMBOL)
  )
)




; TWISTER ---------------------------------------------------------------------


(defclass COLOR (is-a INITIAL-OBJECT)
  (slot id
    (type SYMBOL)
  )
)

(defclass EXTREMIDAD (is-a INITIAL-OBJECT)
  (slot id
    (type SYMBOL)
  )
)

(defclass ELECCION (is-a INITIAL-OBJECT)
  (slot color
    (type SYMBOL)
  )

  (slot extremidad
    (type SYMBOL)
  )

  (slot repeticiones
    (type INTEGER)
    (default 0)
  )
)


(definstances twister
  ; ([control] of CONTROL (turno robot))
  ([rojo] of COLOR (id rojo))
  ([azul] of COLOR (id azul))
  ([amarillo] of COLOR (id amarillo))
  ([verde] of COLOR (id verde))
  ([mano-derecha] of EXTREMIDAD (id mano-derecha))
  ([mano-izquierda] of EXTREMIDAD (id mano-izquierda))
  ([pie-derecho] of EXTREMIDAD (id pie-derecho))
  ([pie-izquierdo] of EXTREMIDAD (id pie-izquierdo))
  ([twister] of JUEGO (id twister) (explicacion "Tienes que colocar la extremidad que te vaya diciendo en el color que te diga. Tienes que intentar no caerte.") (turno-inicial robot))
)


(defclass CASILLA (is-a INITIAL-OBJECT)
  (slot x
    (type INTEGER)
  )

  (slot y
    (type INTEGER)
  )

  (slot valor
    (type SYMBOL)
    (default vacio)
  )
)

(definstances tres-en-raya
  ([c11] of CASILLA (x 1) (y 1))
  ([c12] of CASILLA (x 1) (y 2))
  ([c13] of CASILLA (x 1) (y 3))
  ([c21] of CASILLA (x 2) (y 1))
  ([c22] of CASILLA (x 2) (y 2))
  ([c23] of CASILLA (x 2) (y 3))
  ([c31] of CASILLA (x 3) (y 1))
  ([c32] of CASILLA (x 3) (y 2))
  ([c33] of CASILLA (x 3) (y 3))
  ([tres-en-raya] of JUEGO (id tres-en-raya) (explicacion "Tienes que colocar la ficha en el tablero y conseguir poner 3 en línea. Empiezas tú.") (turno-inicial paciente))
)
