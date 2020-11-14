; Jerarquía de clases

(defclass ACCION (is-a INITIAL-OBJECT)
  (slot nombre
    (type STRING)
  )

  (slot resultado
    (type STRING)
  )
)

(defclass PACIENTE (is-a INITIAL-OBJECT)
  (slot nombre
    (type STRING)
  )

  (slot personalidad
    (type SYMBOL)
    (allowed-values despistado energetico)
  )

  (slot mano
    (type SYMBOL)
    (allowed-values derecha izquierda)
  )

  (slot pie
    (type SYMBOL)
    (allowed-values derecho izquierdo)
  )
)

(defclass ROBOT (is-a INITIAL-OBJECT)
  (slot color-ojos
    (type SYMBOL)
    (allowed-values rojo verde normal)
    (default normal)
  )
)

(defclass JUEGO (is-a INITIAL-OBJECT)
  (slot nombre
    (type SYMBOL)
    (allowed-values 3-en-raya twister)
  )

  (slot explicacion
    (type STRING)
  )

  (slot resultado
    (type SYMBOL)
  )
)

(defclass 3-EN-RAYA (is-a JUEGO)
  (slot nombre
    (source composite)
    (default 3-en-raya)
  )

  (slot explicacion
    (source composite)
    (default "Tenemos que colocar las fichas por turnos para consiguir poner 3 en línea recta. Tu empiezas.")
  )

  (slot resultado
    (source composite)
    (allowed-values empate victoria-paciente victoria-robot)
  )
)


(defclass TWISTER (is-a JUEGO)
  (slot nombre
    (source composite)
    (default twister)
  )

  (slot explicacion
    (source composite)
    (default "Tienes que colocar la extremidad que te vaya diciendo en el color que te diga. Tienes que intentar no caerte.")
  )

  (slot resultado
    (source composite)
    (allowed-values no-decidido victoria-paciente derrota-paciente)
  )
)
