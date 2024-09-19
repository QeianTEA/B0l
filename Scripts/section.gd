extends Area2D

@export var MaxOperators = 2

@export var operatorNumber = 0
@export var enemyPresent = false
@export var damaged = true

@onready var marker_2d = $Marker2D
@onready var marker_2d_2 = $Marker2D2

signal walkOrder

## Area2D mouse clicker script and signal the operator thanksyo

func _on_body_entered(body):
	if body.is_in_group("Operators"):
		
		operatorNumber += 1
		
		if enemyPresent:
			body.attack = true
		elif  damaged:
			body.repair = true
		elif operatorNumber >= MaxOperators:
			body.full = true
		else:
			pass
		
		print(operatorNumber)
		
		body.SectionEntered()



func _on_body_exited(body):
	if body.is_in_group("Operators"):
		var op = body.get_script()
		operatorNumber -= 1
		body.full = false
		body.repair = false
		body.attack = false


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed:
			emit_signal("walkOrder")
		#print(event)
