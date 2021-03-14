(defclass ANIMAL (is-a USER)
	(slot nameee
		(type STRING)
		(default ?NONE))
	(slot skin
		(type SYMBOL)
		(allowed-values hair feathers)
		(default ?NONE))
	(slot fly
		(type SYMBOL)
		(allowed-values yes no)
		(default ?NONE))
	(slot think
		(type SYMBOL)
		(allowed-values yes no)
		(default ?NONE))
)

(defclass MAMMAL (is-a ANIMAL)
	(slot skin
		(source composite)
		(default hair))
	(slot fly
		(source composite)
		(default no))
)

(defclass BIRD (is-a ANIMAL)
	(slot skin
		(source composite)
		(default feathers))
	(slot think
		(source composite)
		(default no))
)

(defclass HUMAN (is-a MAMMAL)
	(slot think
		(source composite)
		(default yes))
)

(defclass ALBATROSS (is-a BIRD)
	(slot fly
		(source composite)
		(default yes))
)

(defclass PENGUIN (is-a BIRD)
	(slot fly
		(source composite)
		(default no))
)


(definstances initial-state
  (of HUMAN (nameee Pepe))
  (of ALBATROSS (nameee Alf))
  (of PENGUIN (nameee Chill))
)


(defrule print-penguins
	(object (is-a PENGUIN) (nameee ?name))
	=>
	(printout t ?name crlf)
)
