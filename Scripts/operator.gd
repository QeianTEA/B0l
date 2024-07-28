extends CharacterBody2D

@export var selected = false
@onready var anim = $AnimatedSprite2D

@onready var box = $Selected

@export var MaxHp = 100
@export var Speed = 150
var health

var section_left = null
var section_right = null

var attack = false
var repair = false
var full = false

@warning_ignore("unassigned_variable", "unused_parameter")

func _ready():
	set_selected(selected)
	box.visible = false
	health = MaxHp;
	State(1)

func set_selected(value):
	selected = value
	box.visible = value
	
func _input(_event):
	pass

func _physics_process(_delta: float) -> void:
	
	if selected:
		pass

	if position:  # ??? what to do
		move_and_slide()
	else:
		#anim.stop()
		pass

func SectionEntered():
	if attack:
		#Attack()
		State(3)
	elif repair:
		#Repair()
		State(4)
	elif full:
		#Idle walk()
		State(2)
	else:
		#CheckGun()
		State(5)

func State(nunmber):
	match(nunmber):
		1: #idle
			anim.play("idle")
		2: #moving / jumping
			anim.play("walk")
		3: #attacking
			anim.play("attack")
		4: #repearing
			anim.play("repair")
		5: #checking gun
			anim.play("check")
