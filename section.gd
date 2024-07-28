extends Area2D

@export var MaxOperators = 2


@onready var operatorNumber = 0
@onready var enemyPresent = false
@onready var damaged = true

func _on_body_entered(body):
	if body.is_in_group("Operators"):
		
		var op = body.get_script()
		
		get_tree().call_group("Operators", "SectionEntered")
		operatorNumber += 1
		
		if enemyPresent:
			op.attack = true
		elif  damaged:
			op.repair = true
		elif operatorNumber <= MaxOperators:
			op.full = true
		else:
			pass



func _on_body_exited(body):
	if body.is_in_group("Operators"):
		var op = body.get_script()
		operatorNumber -= 1
		op.full = false
		op.repair = false
		op.attack = false
