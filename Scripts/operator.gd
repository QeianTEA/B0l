extends CharacterBody2D

@export var selected = false
#@onready var anim = $AnimationPlayer
@onready var box = $Selected



@onready var target = position
var follow_cursor = false
@export var Speed = 150


var target_node = null
var home_pos = Vector2.ZERO

@warning_ignore("unassigned_variable", "unused_parameter")

func _ready():
	set_selected(selected)
	home_pos = self.global_position
	box.visible = false
	

func set_selected(value):
	selected = value
	box.visible = value
	
func _input(_event):
	pass

func _physics_process(_delta: float) -> void:
	
	if selected:
		pass

	if position.distance_to(target) > 30:
		move_and_slide()
	else:
		#anim.stop()
		pass

func State(nunmber):
	match(nunmber):
		1:
			print("Su iç")
		2:
			print("Su içme")
