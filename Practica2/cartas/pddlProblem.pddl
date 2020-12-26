(define (problem Problema1)
(:domain auto)
(:objects
	Alba - Paciente
	Granja Jungla Mar - Contador
	Cerdo1 Cerdo2 Vaca1 Vaca2 - Carta
	Mono1 Mono2 Serpiente1 Serpiente2 - Carta
	Delfin1 Delfin2 PezEspada1 PezEspada2 - Carta

)
(:init
	(RondaInicial Granja)
	(Siguiente Granja Jungla)
	(Siguiente Jungla Mar)

	(CartaEnRonda Cerdo1 Granja)
	(CartaEnRonda Cerdo2 Granja)
	(CartaEnRonda Vaca1 Granja)
	(CartaEnRonda Vaca2 Granja)

	(ParejaCartas Cerdo1 Cerdo2)
	(ParejaCartas Vaca1 Vaca2)

	(CartaEnRonda Mono1 Jungla)
	(CartaEnRonda Mono2 Jungla)
	(CartaEnRonda Serpiente1 Jungla)
	(CartaEnRonda Serpiente2 Jungla)

	(ParejaCartas Mono1 Mono2)
	(ParejaCartas Serpiente1 Serpiente2)

	(CartaEnRonda Delfin1 Mar)
	(CartaEnRonda Delfin2 Mar)
	(CartaEnRonda PezEspada1 Mar)
	(CartaEnRonda PezEspada2 Mar)

	(ParejaCartas Delfin1 Delfin2)
	(ParejaCartas PezEspada1 PezEspada2)

	(ExistePaciente Alba)
)
(:goal
   (and
		(Despedido Alba)
   )
)
)
