; Jerarquía de clases

(defclass ESTADO (is-a INITIAL-OBJECT)
  (slot turno
    (type SYMBOL)
    (allowed-values turno-robot turno-paciente)
  )

  (slot num-acciones
    (type INTEGER)
    (default 0)
  )

  (slot acciones-max
    (type INTEGER)
    (default 10)
  )
)

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
  (slot color-indicado
    (type SYMBOL)
    (allowed-values no rojo amarillo azul verde)
    (default no)
  )

  (slot extremidad-indicada
    (type SYMBOL)
    (allowed-values no pie-derecho pie-izquierdo mano-derecha mano-izquierda)
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
  ([estado] of ESTADO (turno turno-robot))
  ([twister] of TWISTER)
  ([paciente] of PACIENTE (nombre Pepe) (personalidad despistado))

  (of ACCION (nombre saludar))
  ([saludar-explicar] of FLUJO (accion-actual saludar) (accion-resultante explicar) (imprimir "¡Hola!"))


  ([explicarTwister-elegir] of FLUJO-TWISTER (accion-actual explicar) (accion-resultante elegir) (imprimir "Tienes que colocar la extremidad que te vaya diciendo en el color que te diga. Tienes que intentar no caerte."))




  ;  ?¿ -> Preguntar
  ([elegir-colocar] of FLUJO-TWISTER (accion-actual elegir) (accion-resultante colocar) (imprimir ""))
  (colocarNormal-lasjd) elegir -> colocar
  (colocarDespistado-lasjd) elegir -> volver-explicar
  (colocarEnergetico-lasjd) elegir -> moverse

  colocar -> check-bien
  colocar -> check-mal
  colocar -> paciente-caido




  ([comprobarBien-elegir] of FLUJO-TWISTER (accion-actual comprobar-bien) (accion-resultante elegir) (imprimir "Enhorabuena, muy bien hecho"))

  ([terminar-despedirse] of FLUJO (accion-actual terminar-juego) (accion-resultante despedirse) (imprimir "Hemos terminado el juego"))

  ([despedirse-apagar] of FLUJO (accion-actual despedirse) (accion-resultante apagar-robot) (imprimir "Hasta otra"))
)

(deffacts inicial-facts
  (color rojo)
  (color verde)
  (color amarillo)
  (color azul)
  (extremidad mano-derecha)
  (extremidad mano-izquierda)
  (extremidad pie-derecho)
  (extremidad pie-izquierdo)
)
