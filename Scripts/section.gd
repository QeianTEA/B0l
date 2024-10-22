extends Area2D

@export var MaxOperators = 2

@export var operatorNumber = 0
@export var enemyPresent = false
@export var damaged = true

@onready var section = $"."

var bodiesInside = []

## Area2D mouse clicker script and signal the operator thanksyo

func sitrep(): #situation report -> sitrep get it?
	for e in bodiesInside.size():
		bodiesInside[e].SectionEntered()

func _on_body_entered(body):
	if body.is_in_group("Operators"):
			operatorNumber += 1
			bodiesInside.append(body) # add to the list
			body.operatorNum = operatorNumber
			body.SectionObj = section
			if enemyPresent:
				body.attack = true
				body.SectionEntered()
			elif damaged:
				body.repair = true
			elif operatorNumber > MaxOperators:
				body.full = true
			else:
				pass
		
			print(operatorNumber)
			pass
	




func _on_body_exited(body):
	if body.is_in_group("Operators"):
		operatorNumber -= 1
		bodiesInside.erase(body)
		body.full = false
		body.repair = false
		body.attack = false
		body.idle = false
		body.checking = false
		body.repairMove = false
		body.SectionObj = null
		pass
	
	sitrep()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed:
			for gameObject in get_tree().get_nodes_in_group("Operators"):
				if gameObject.selected:
					gameObject.section_position = position
					gameObject._on_section_walk_order()
					print("order sent")

#func _on_area_2d_body_entered_middle(body):
#	if body.is_in_group("Operators"):
#		if (Vector2(position.x + 40, 0).distance_to(Vector2(body.position.x, 0)) < 30):
