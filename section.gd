extends Area2D

@export var MaxOperators = 2

@onready var operatorNumber = 0
@onready var enemyPresent = false
@onready var damaged = true




func _on_body_entered(body):
	if body.is_in_group("Operators"):
		
		operatorNumber += 1
		
		if enemyPresent:
			body.attack = true
		elif  damaged:
			body.repair = true
		elif operatorNumber <= MaxOperators:
			body.full = true
		else:
			pass
		
		body.SectionEntered()



func _on_body_exited(body):
	if body.is_in_group("Operators"):
		var op = body.get_script()
		operatorNumber -= 1
		body.full = false
		body.repair = false
		body.attack = false
