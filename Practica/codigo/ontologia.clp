; Jerarquía de clases

(defclass ACCION (is-a INITIAL-OBJECT)
  (slot nombre
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

  (slot extremidad
    (type SYMBOL)
    (allowed-values mano-derecha mano-izquierda pie-derecho pie-izquierdo)
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

  (slot resultado
    (type SYMBOL)
  )
)

(defclass 3-EN-RAYA (is-a JUEGO)
  (slot nombre
    (source composite)
    (default 3-en-raya)
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

  (slot resultado
    (source composite)
    (allowed-values no-decidido victoria-paciente derrota-paciente)
    (default no-decidido)
  )

  ; Lo que ha indicado el robot
  (slot indicado
    (type SYMBOL)
    (allowed-values no rojo amarillo azul verde)
    (default no)
  )
)

(defclass FLUJO (is-a INITIAL-OBJECT)
  (slot accion-actual
    (type STRING)
  )

  (slot accion-resultante
    (type STRING)
  )

  (slot imprimir
    (type STRING)
  )
)

(defclass FLUJO-TWISTER (is-a FLUJO)
  (slot comando
    (type SYMBOL)
    (default -)
  )
)

(defclass FLUJO-3-EN-RAYA (is-a FLUJO))


; Instancias

(definstances inicial
  (of ACCION (nombre saludar))
  ([saludar-explicar] of FLUJO (accion-actual saludar) (accion-resultante explicar) (imprimir "¡Hola!"))

  ([twister] of TWISTER)

  ([explicarTwister-elegir] of FLUJO-TWISTER (accion-actual explicar) (accion-resultante elegir) (imprimir "Tienes que colocar la extremidad que te vaya diciendo en el color que te diga. Tienes que intentar no caerte."))

  ([elegir-colocar] of FLUJO-TWISTER (accion-actual elegir) (accion-resultante colocar) (imprimir ""))


  (colocarNormal-lasjd) resultado -> comprobar
  (colocarDespistado-lasjd) resultado -> volver-explicar
  (colocarEnergetico-lasjd) resultado -> moverse
)

(deffacts inicial-facts

  CREAR-SESION(JUEGO, PACIENTE/PERSONALIDAD)

  (color rojo)
  (color verde)
  (color amarillo)
  (color azul)
  (extremidad mano-derecha)
  (extremidad mano-izquierda)
  (extremidad pie-derecho)
  (extremidad pie-izquierdo)
)
