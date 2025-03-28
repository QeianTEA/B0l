extends Area2D

@export var MaxOperators = 2

var operatorNumber = 0
@export var enemyPresent = false
@export var damaged = false
@onready var section = self

var bodiesInside = []

func _ready():
	enemyPresent = false
	
	sitrep()

func _physics_process(delta):
	sitrep()

func sitrep(): #situation report -> sitrep get it?
	for e in bodiesInside.size():
		operatorNumber = bodiesInside.size()
		if !bodiesInside[e].on_his_way: 
			if operatorNumber > MaxOperators:
				if e > MaxOperators:
					bodiesInside[e].full = true
				else:
					bodiesInside[e].full = false
			bodiesInside[e].SectionObj = section
			bodiesInside[e].operatorNum = e
			bodiesInside[e].section_position = position

func _on_body_entered(body):
	if body.is_in_group("Operators"):
			operatorNumber += 1
			bodiesInside.append(body) # add to the list
			body.operatorNum = operatorNumber
			body.SectionObj = section
		
			print(operatorNumber)
			pass	

func _on_body_exited(body):
	if body.is_in_group("Operators"):
		operatorNumber -= 1
		bodiesInside.erase(body)
		pass

#func _on_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == 2 and event.pressed:
			#for gameObject in get_tree().get_nodes_in_group("Operators"):
				#if gameObject.selected:
					#gameObject.section_position = position
					#gameObject.SectionObj = section
					#gameObject._on_section_walk_order()
					#print("order sent")

#func _on_area_2d_body_entered_middle(body):
#	if body.is_in_group("Operators"):
#		if (Vector2(position.x + 40, 0).distance_to(Vector2(body.position.x, 0)) < 30):

