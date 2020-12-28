(define (domain auto)
	(:requirements :strips :typing :fluents :negative-preconditions :equality)
	(:types
	    Paciente - object
	    Carta - object
	    Contador - object
	)

  (:constants
    paciente nao - contador
  )

	(:predicates
	    (ExistePaciente ?p - Paciente)
	    (Identificado ?ido - Paciente)
      (Saludado ?sp - Paciente)
      (JuegoExplicado ?jp - Paciente)
      (RondaInicial ?r1 - Contador)
      (RondaActual ?r1 - Contador)
      (Siguiente ?r1 ?r2 - Contador)
      (Turno ?t - Contador)
      (CartaEnRonda ?c - Carta ?r - Contador)
      (ParejaCartas ?c1 - Carta ?c2 - Carta)
      (CartaBocaArriba ?c - Carta)
	    (CartaRecordada ?c - Carta)
      (CartaEmparejada ?c - Carta)
      (JuegoTerminado)
      (Despedido ?p - Paciente)
	)

  (:functions
      (ContadorBocaArriba)
      (ContadorRecordadas)
			(ContadorErrores)
  )

  (:action Identificar_Paciente
  	:parameters	(?p - Paciente)
  	:precondition (and
  			(ExistePaciente ?p)
  			(not (Identificado ?p))
  		       )
  	:effect	 (and
  			(Identificado ?p)
  		  )
  )

  (:action Saludar_Paciente
  	:parameters	(?p - Paciente)
  	:precondition (and
  			(Identificado ?p)
  			(not (Saludado ?p))
  		       )
  	:effect	 (and
  			(Saludado ?p)
  		  )
  )

  (:action Explicar_Juego
  	:parameters	(?p - Paciente)
  	:precondition (and
  			(Saludado ?p)
  			(not (JuegoExplicado ?p))
  		       )
  	:effect	 (and
  			(JuegoExplicado ?p)
  		  )
  )

  (:action Comenzar_Sesion
  	:parameters	(?p - Paciente ?r - Contador)
  	:precondition (and
  			(JuegoExplicado ?p)
        (RondaInicial ?r)
  		       )
  	:effect	 (and
        (RondaActual ?r)
        (assign (ContadorBocaArriba) -1)
        (not (RondaInicial ?r))


				(assign (ContadorErrores) 0)
  		  )
  )

  (:action Comenzar_Ronda
  	:parameters	(?r - Contador)
  	:precondition (and
  			(RondaActual ?r)
        (= (ContadorBocaArriba) -1)
        (not (Turno paciente))
        (not (Turno nao))
  		       )
  	:effect	 (and
  			(Turno paciente)
        (increase (ContadorBocaArriba) 1)
        (assign (ContadorRecordadas) 0)
  		  )
  )

  (:action Girar_Sin_Conocimiento
  	:parameters	(?c - Carta ?r - Contador)
  	:precondition (and
  			(= (ContadorRecordadas) 0)
        (>= (ContadorBocaArriba) 0)
        (< (ContadorBocaArriba) 2)
  			(CartaEnRonda ?c ?r)
        (RondaActual ?r)
        (not (CartaBocaArriba ?c))
  		       )
  	:effect	 (and
  			(CartaBocaArriba ?c)
  			(CartaRecordada ?c)
  			(increase (ContadorBocaArriba) 1)
        (increase (ContadorRecordadas) 1)
  		  )
  )

  (:action Girar_Con_Conocimiento
  	:parameters	(?c ?oc - Carta ?r - Contador)
  	:precondition (and
        (>= (ContadorBocaArriba) 0)
        (< (ContadorBocaArriba) 2)
        (CartaRecordada ?oc)
  			(CartaEnRonda ?c ?r)
        (RondaActual ?r)
        (not (CartaBocaArriba ?c))
  		       )
  	:effect	 (and
  			(CartaBocaArriba ?c)
  			(CartaRecordada ?c)
  			(increase (ContadorBocaArriba) 1)
        (increase (ContadorRecordadas) 1)
  		  )
  )

  (:action Girar_Recordada
  	:parameters	(?r - Contador ?c - Carta)
  	:precondition (and
        (>= (ContadorBocaArriba) 0)
        (< (ContadorBocaArriba) 2)
  			(CartaEnRonda ?c ?r)
        (RondaActual ?r)
  			(CartaRecordada ?c)
  			(not (CartaBocaArriba ?c))
  		       )
  	:effect	 (and
  			(CartaBocaArriba ?c)
  			(increase (ContadorBocaArriba) 1)
  		  )
  )

  (:action Comprobar_Pareja_Bien
  	:parameters	(?c1 ?c2 - Carta ?r - Contador)
  	:precondition (and
        (not ( = ?c1 ?c2))
  			(CartaBocaArriba ?c1)
  			(CartaBocaArriba ?c2)
  			(or
          (ParejaCartas ?c1 ?c2)
          (ParejaCartas ?c2 ?c1)
        )
  			(not (CartaEmparejada ?c1))
  			(not (CartaEmparejada ?c2))
  			(CartaEnRonda ?c1 ?r)
        (CartaEnRonda ?c2 ?r)
        (RondaActual ?r)
        (= (ContadorBocaArriba) 2)
  		       )
  	:effect	 (and
  			(CartaEmparejada ?c1)
  			(CartaEmparejada ?c2)
  			(assign (ContadorBocaArriba) -1)
        (decrease (ContadorRecordadas) 2)
        (not (CartaRecordada ?c1))
        (not (CartaRecordada ?c2))
  		  )
  )

  (:action Comprobar_Pareja_Mal
  	:parameters	(?c1 ?c2 - Carta ?r - Contador)
  	:precondition (and
        (not ( = ?c1 ?c2))
  			(CartaBocaArriba ?c1)
  			(CartaBocaArriba ?c2)
        (not (ParejaCartas ?c1 ?c2))
        (not (ParejaCartas ?c2 ?c1))
  			(not (CartaEmparejada ?c1))
  			(not (CartaEmparejada ?c2))
  			(CartaEnRonda ?c1 ?r)
        (CartaEnRonda ?c2 ?r)
        (RondaActual ?r)
        (= (ContadorBocaArriba) 2)
  		       )
  	:effect	 (and
        (not (CartaBocaArriba ?c1))
        (not (CartaBocaArriba ?c2))
  			(assign (ContadorBocaArriba) -1)


				(increase (ContadorErrores) 1)
  		  )
  )

  (:action Cambiar_Turno_A_Robot
  	:parameters	()
  	:precondition (and
  			(Turno paciente)
  			(= (ContadorBocaArriba) -1)
  		       )
  	:effect	 (and
        (not (Turno paciente))
        (Turno nao)
        (assign (ContadorBocaArriba) 0)
  		  )
  )

  (:action Cambiar_Turno_A_Paciente
  	:parameters	()
  	:precondition (and
  			(Turno nao)
  			(= (ContadorBocaArriba) -1)
  		       )
  	:effect	 (and
        (not (Turno nao))
        (Turno paciente)
        (assign (ContadorBocaArriba) 0)
  		  )
  )

  (:action Terminar_Ronda
  	:parameters	(?r ?sr - Contador)
  	:precondition (and
        (= (ContadorBocaArriba) -1)
        (not (exists (?c - Carta)
              (and
                (not (CartaEmparejada ?c))
                (CartaEnRonda ?c ?r)
              )
        ))
        (Siguiente ?r ?sr)
        (RondaActual ?r)
  		       )
  	:effect	 (and
        (not (RondaActual ?r))
        (RondaActual ?sr)
        (not (Turno paciente))
        (not (Turno nao))
  		  )
  )

  (:action Terminar_Juego
  	:parameters	(?r - Contador)
  	:precondition (and
        (= (ContadorBocaArriba) -1)
        (not (exists (?c - Carta)
              (and
                (not (CartaEmparejada ?c))
                (CartaEnRonda ?c ?r)
              )
        ))
        (not (exists (?sr - Contador)
              (and
                (Siguiente ?r ?sr)
              )
        ))
        (RondaActual ?r)
  		       )
  	:effect	 (and
        (JuegoTerminado)
  		  )
  )

  (:action Despedir_Paciente
  	:parameters	(?p - Paciente)
  	:precondition (and
        (JuegoTerminado)
  		       )
  	:effect	 (and
        (Despedido ?p)
  		  )
  )

)
