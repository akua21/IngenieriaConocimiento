(define (problem Problema1)
(:domain auto)
(:objects
	Teo - Paciente
	Granja Jungla Mar Desierto - Contador
	Cerdo1 Cerdo2 Vaca1 Vaca2 Caballo1 Caballo2 Pato1 Pato2 - Carta
	Mono1 Mono2 Serpiente1 Serpiente2 Tigre1 Tigre2 Loro1 Loro2 - Carta
	Delfin1 Delfin2 Pez1 Pez2 Tiburon1 Tiburon2 Pulpo1 Pulpo2 - Carta
	Escorpion1 Escorpion2 Camello1 Camello2 Coyote1 Coyote2 Hormiga1 Hormiga2 - Carta
)
(:init
	(RondaInicial Granja)
	(Siguiente Granja Jungla)
	(Siguiente Jungla Mar)
	(Siguiente Mar Desierto)


	(CartaEnRonda Cerdo1 Granja)
	(CartaEnRonda Cerdo2 Granja)
	(CartaEnRonda Vaca1 Granja)
	(CartaEnRonda Vaca2 Granja)
	(CartaEnRonda Caballo1 Granja)
	(CartaEnRonda Caballo2 Granja)
	(CartaEnRonda Pato1 Granja)
	(CartaEnRonda Pato2 Granja)

	(ParejaCartas Cerdo1 Cerdo2)
	(ParejaCartas Vaca1 Vaca2)
	(ParejaCartas Caballo1 Caballo2)
	(ParejaCartas Pato1 Pato2)

	(CartaEnRonda Mono1 Jungla)
	(CartaEnRonda Mono2 Jungla)
	(CartaEnRonda Serpiente1 Jungla)
	(CartaEnRonda Serpiente2 Jungla)
	(CartaEnRonda Tigre1 Jungla)
	(CartaEnRonda Tigre2 Jungla)
	(CartaEnRonda Loro1 Jungla)
	(CartaEnRonda Loro2 Jungla)

	(ParejaCartas Mono1 Mono2)
	(ParejaCartas Serpiente1 Serpiente2)
	(ParejaCartas Tigre1 Tigre2)
	(ParejaCartas Loro1 Loro2)

	(CartaEnRonda Delfin1 Mar)
	(CartaEnRonda Delfin2 Mar)
	(CartaEnRonda Pez1 Mar)
	(CartaEnRonda Pez2 Mar)
	(CartaEnRonda Tiburon1 Mar)
	(CartaEnRonda Tiburon2 Mar)
	(CartaEnRonda Pulpo1 Mar)
	(CartaEnRonda Pulpo2 Mar)

	(ParejaCartas Delfin1 Delfin2)
	(ParejaCartas Pez1 Pez2)
	(ParejaCartas Tiburon1 Tiburon2)
	(ParejaCartas Pulpo1 Pulpo2)

	(CartaEnRonda Escorpion1 Desierto)
	(CartaEnRonda Escorpion2 Desierto)
	(CartaEnRonda Camello1 Desierto)
	(CartaEnRonda Camello2 Desierto)
	(CartaEnRonda Coyote1 Desierto)
	(CartaEnRonda Coyote2 Desierto)
	(CartaEnRonda Hormiga1 Desierto)
	(CartaEnRonda Hormiga2 Desierto)

	(ParejaCartas Escorpion1 Escorpion2)
	(ParejaCartas Camello1 Camello2)
	(ParejaCartas Coyote1 Coyote2)
	(ParejaCartas Hormiga1 Hormiga2)

	(ExistePaciente Teo)
)
(:goal
   (and
		(Despedido Teo)
   )
)
)
