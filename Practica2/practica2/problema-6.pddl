(define (problem Problema1)
(:domain auto)
(:objects
	Teo - Paciente
	Granja Jungla - Contador
	Cerdo1 Cerdo2 Vaca1 Vaca2 Caballo1 Caballo2 - Carta
	Mono1 Mono2 Serpiente1 Serpiente2 Tigre1 Tigre2 - Carta
)
(:init
	(RondaInicial Granja)
	(Siguiente Granja Jungla)

	(CartaEnRonda Cerdo1 Granja)
	(CartaEnRonda Cerdo2 Granja)
	(CartaEnRonda Vaca1 Granja)
	(CartaEnRonda Vaca2 Granja)
	(CartaEnRonda Caballo1 Granja)
	(CartaEnRonda Caballo2 Granja)

	(CartaBocaArriba Vaca2)
	(CartaBocaArriba Caballo1)

	(ParejaCartas Cerdo1 Cerdo2)
	(ParejaCartas Vaca1 Vaca2)
	(ParejaCartas Caballo1 Caballo2)

	(CartaEnRonda Mono1 Jungla)
	(CartaEnRonda Mono2 Jungla)
	(CartaEnRonda Serpiente1 Jungla)
	(CartaEnRonda Serpiente2 Jungla)
	(CartaEnRonda Tigre1 Jungla)
	(CartaEnRonda Tigre2 Jungla)

	(CartaBocaArriba Mono2)
	(CartaBocaArriba Serpiente2)

	(ParejaCartas Mono1 Mono2)
	(ParejaCartas Serpiente1 Serpiente2)
	(ParejaCartas Tigre1 Tigre2)

	(ExistePaciente Teo)

	(Despistado Teo)
)
(:goal
   (and
		(Despedido Teo)
		( = (ContadorErrores) 3)
   )
)
)
