(define (problem Problema1)
(:domain auto)
(:objects
	Teo - Paciente
	Granja Jungla - Contador
	Vaca1 Vaca2 Caballo1 Caballo2 - Carta
	Serpiente1 Serpiente2 Tigre1 Tigre2 - Carta
)
(:init
	(RondaInicial Granja)
	(Siguiente Granja Jungla)

	(CartaEnRonda Vaca1 Granja)
	(CartaEnRonda Vaca2 Granja)
	(CartaEnRonda Caballo1 Granja)
	(CartaEnRonda Caballo2 Granja)

	(ParejaCartas Vaca1 Vaca2)
	(ParejaCartas Caballo1 Caballo2)

	(CartaEnRonda Serpiente1 Jungla)
	(CartaEnRonda Serpiente2 Jungla)
	(CartaEnRonda Tigre1 Jungla)
	(CartaEnRonda Tigre2 Jungla)

	(ParejaCartas Serpiente1 Serpiente2)
	(ParejaCartas Tigre1 Tigre2)

	(ExistePaciente Teo)
	(Despistado Teo)
)
(:goal
   (and
		(Despedido Teo)
   )
)
)
