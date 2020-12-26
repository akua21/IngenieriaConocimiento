(define (domain auto)
	(:requirements :strips :typing :fluents :negative-preconditions :equality)
	(:types
	    Paciente
	    Carta
	    Contador
	)

	(:predicates
	    (ExistePaciente ?p - Paciente)
	    (Identificado ?ido - Paciente)
	    (Saludado ?sp - Paciente)
	    (JuegoExplicado ?jp - Paciente)
	    (CartaEnRonda ?c - Carta ?r - Contador)
	    (ParejaCartas ?c1 - Carta ?c2 - Carta)
	    (CartaBocaArriba ?c - Carta)
	    (CartaRecordada ?c - Carta)
	    (JuegoTerminado)
	    (Turno ?t - Contador)
	    (CartaEmparejada ?c - Carta)
	)

	(:functions
	    (NumRondas)
	    (RondaActual)
	    (ContadorBocaArriba)
	)

(:action IdentificarPaciente
	:parameters	(?p - Paciente)
	:precondition (and
			(ExistePaciente ?p)
			(not (Identificado ?p))
		       )
	:effect	 (and
			(Identificado ?p)
		  )
)

(:action SaludarPaciente
	:parameters	(?p-Paciente )
	:precondition (and
			(Identificado ?p)
			(not (Saludado ?p))
		       )
	:effect	 (and
			(Saludado ?p)
		  )
)

(:action ExplicarJuego
	:parameters	(?p-Paciente )
	:precondition (and
			(Saludado ?p)
			(not (JuegoExplicado ?p))
		       )
	:effect	 (and
			(JuegoExplicado ?p)
		  )
)

(:action ComenzarSesion
	:parameters	(?p-Paciente )
	:precondition (and
			(JuegoExplicado ?p)
			(> (NumRondas)(RondaActual))
		       )
	:effect	 (and
			(increase (RondaActual)(RondaActual))
		  )
)

(:action ComenzarRonda
	:parameters	(?paciente-Contador )
	:precondition (and
			(> (RondaActual)(RondaActual))
		       )
	:effect	 (and
			(Turno ?paciente)
		  )
)

(:action GirarSinConocimie
	:parameters	(?c-Carta )
	:precondition (and
			(not (CartaRecordada))
			(CartaEnRonda)
			(= (NumRondas)(NumRondas))
			(= (NumRondas)(NumRondas))
			(= (NumRondas)(NumRondas))
		       )
	:effect	 (and
			(CartaBocaArriba ?c)
			(CartaRecordada ?c)
			(increase (ContadorBocaArriba)(ContadorBocaArriba))
		  )
)

(:action GirarConConoc
	:parameters	(?c-Carta ?r-Contador ?nc-Carta )
	:precondition (and
			(CartaEnRonda ?c ?r)
			(CartaRecordada ?nc)
			(CartaBocaArriba ?c)
			(= (RondaActual)(RondaActual))
			(>= (ContadorBocaArriba)(ContadorBocaArriba))
			(< (ContadorBocaArriba)(ContadorBocaArriba))
		       )
	:effect	 (and
		  )
)

(:action GirarRecordada
	:parameters	(?r-Contador ?c-Carta )
	:precondition (and
			(CartaEnRonda ?r ?c)
			(CartaRecordada ?c)
			(not (CartaBocaArriba ?c))
			(>= (ContadorBocaArriba)(ContadorBocaArriba))
			(< (ContadorBocaArriba)(ContadorBocaArriba))
		       )
	:effect	 (and
			(CartaBocaArriba ?c)
			(increase (ContadorBocaArriba)(ContadorBocaArriba))
		  )
)

(:action ComprobarParejaBi
	:parameters	(?c1-Carta ?c2-Carta )
	:precondition (and
			(CartaBocaArriba ?c1)
			(CartaBocaArriba ?c2)
			(CartaEmparejada ?c2)
			(ParejaCartas)
			(not (CartaEmparejada ?c1))
			(not (CartaEmparejada ?c2))
			(CartaEnRonda)
			(CartaEnRonda)
		       )
	:effect	 (and
			(CartaEmparejada ?c1)
			(CartaEmparejada ?c2)
			(assign (ContadorBocaArriba)(ContadorBocaArriba))
		  )
)

(:action ComprobarParejasM
	:parameters	(?c1-Carta ?c2-Carta )
	:precondition (and
			(CartaBocaArriba ?c1)
			(CartaBocaArriba ?c2)
			(CartaEmparejada ?c1)
			(CartaEmparejada ?c2)
			(not (ParejaCartas ?c1 ?c2))
		       )
	:effect	 (and
			(not (CartaBocaArriba ?c1))
			(not (CartaBocaArriba ?c2))
			(assign (ContadorBocaArriba)(ContadorBocaArriba))
		  )
)

(:action CambiarTurnoARobo
	:parameters	(?paciente-Contador ?c-Carta )
	:precondition (and
			(Turno ?paciente)
			(not (CartaBocaArriba ?c))
			(= (ContadorBocaArriba)(ContadorBocaArriba))
		       )
	:effect	 (and
		  )
)

(:action CambiarTurnoAPaci
	:parameters	(?robot-Contador ?c-Carta ?paciente-Contador )
	:precondition (and
			(Turno ?robot)
			(not (CartaBocaArriba ?c))
			(= (ContadorBocaArriba)(ContadorBocaArriba))
		       )
	:effect	 (and
			(not (Turno ?robot))
			(Turno ?paciente)
			(assign (ContadorBocaArriba)(ContadorBocaArriba))
		  )
)

(:action TerminarRonda
	:parameters	()
	:precondition (and
		       )
	:effect	 (and
		  )
)

(:action TerminarJuego
	:parameters	()
	:precondition (and
		       )
	:effect	 (and
		  )
)

(:action DespedirPaciente
	:parameters	()
	:precondition (and
		       )
	:effect	 (and
		  )
)
)
