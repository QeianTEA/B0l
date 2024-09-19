extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var selected = false
var moving = false
@onready var anim = $AnimatedSprite2D

@onready var box = $Selected

@export var MaxHp = 100
@export var MaxSpeed = 150
var health
var speed

var click_position = Vector2()
var section_position = Vector2()

var walkDirection = 1
var walkBobble = 5            #USE THIS BOING BOING MOVING YES

var section_left = null
var section_right = null
var entered = false

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
	click_position = position
	State(1)

func set_selected(value):
	selected = value
	box.visible = value
	
func _input(_event):
	pass

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if moving:       ##its gonna change just temp
		velocity = section_position * speed
		move_and_slide()

func SectionEntered():    
	if attack:   #direkt saldır
		moving = false
		#Attack()
		State(3)
	elif repair: #Sectionun duvarlarına çarpmasın bundan sonrası için !!!!!!!!!!!!!!!!!!!!!!!!1
		#Repair()
		State(4)
	elif full:
		Idle()
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


func _on_section_walk_order():
	if selected:
		if Input.is_action_just_pressed("RightClick"):
			idle = false
			full = false
			attack = false
			checking = false
			repair = false
			moving = true

func Idle():
	pass
