extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var selected = false
@onready var anim = $AnimatedSprite2D

@onready var box = $Selected

@export var MaxHp = 100
@export var MaxSpeed = 150
var health
var speed

var walkDirection = 1

var section_left = null
var section_right = null

var attack = false    #FIREEE!!!
var repair = false    #Fixing the equipment
var full = false      #Section is full
var walking = false   #Moving horizontal
var jump = false      #Moving vertical
var checking = false  #Checking gun
var idle = false      #Idle moving

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

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	if selected:
		pass

	if position:  # ??? what to do
		move_and_slide()
	else:
		#anim.stop()
		pass

func SectionEntered():    
	if attack:   #direkt saldır
		#Attack()
		State(3)
	elif repair: #Sectionun duvarlarına çarpmasın bundan sonrası için !!!!!!!!!!!!!!!!!!!!!!!!1
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
			idle = true
			speed = MaxSpeed/2
		2: #moving / jumping
			anim.play("walk")
			walking = true
			speed = MaxSpeed
			print("walking")
		3: #attacking
			anim.play("attack")
			print("attacking")
		4: #repearing
			anim.play("repair")
			print("repairing")
		5: #checking gun
			anim.play("check")
			checking = true
			print("check")
