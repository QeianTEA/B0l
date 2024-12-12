extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var selected = false

@onready var anim = $AnimatedSprite2D

@onready var box = $Selected

@export var MaxHp = 100
@export var MaxSpeed = 10
var health
var speed: int

var click_position = Vector2()
var section_position = Vector2()
var operatorNum = 0

var walkDirection = 1
var walkBobble = 5            #USE THIS BOING BOING MOVING YES

var SectionObj = null
var full:bool:
	set (value):
		if full != value:  # Only change if the value is different
			full = value
			statusChanged = true
	get:
		return full

var attacking = false    #FIREEE!!!
var repairing = false    #Fixing the equipment
var repairMove = false
var moving = false       #Moving horizontal
var jump = false         #Moving vertical
var checking = false     #Checking gun
var idle = false         #Idle moving

var statusChanged = false

@warning_ignore("unassigned_variable", "unused_parameter")

func _ready():
	set_selected(selected)
	box.visible = false
	full = false
	speed = MaxSpeed
	
	health = MaxHp;
	click_position = position
	#State(1)
	
	var chooser = randi_range(0, 5)
	
	if chooser > 2:
		walkDirection = Vector2(1, 0)
	else:
		walkDirection = Vector2(-1, 0)

func set_selected(value):
	selected = value
	box.visible = value
	
func _input(_event):
	pass

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity < Vector2(0,0):
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	if statusChanged:
		statusChanged = false
		moving = true
		State(2)
		idle = false
	
	if moving && SectionObj != null && !repairMove:
		var direction = (Vector2(section_position.x + 40 , 0) - Vector2(position.x, 0)).normalized()
		velocity = direction * speed
		if Vector2(position.x, 0).distance_to(Vector2(section_position.x + 40, 0)) < 5:
			moving = false
		move_and_slide()
	elif SectionObj != null:
		if SectionObj.enemyPresent:   #direkt saldır
			attacking = true
			#moving = false
			#Attack()
			State(3)
		elif SectionObj.damaged && operatorNum < 3:  #ortaya gel öyle karar ver
			#Repair()
			attacking = false
			State(4)
		elif full:
			#Idle()
			attacking = false
			State(1)
		else:
			#CheckGun()
			attacking = false
			State(5)
	
	if idle && !moving:
		velocity = walkDirection * speed
		move_and_slide()
	
	if repairMove && !moving:
		if SectionObj.operatorNumber > 3:
			repairMove = false
		else:
			match(operatorNum):
				0:
					var directionR = (Vector2(section_position.x + 10, 0) - Vector2(position.x, 0)).normalized()
					velocity = directionR * speed
					if Vector2(position.x, 0).distance_to(Vector2(section_position.x + 10, 0)) < 5:
						repairMove = false
						repairing = true
						anim.play("repair")
					move_and_slide()
				1:
					var directionR = (Vector2(section_position.x + 40, 0) - Vector2(position.x, 0)).normalized()
					velocity = directionR * speed
					if Vector2(position.x, 0).distance_to(Vector2(section_position.x + 40, 0)) < 5:
						repairMove = false
						repairing = true
						anim.play("repair")
					move_and_slide()
				2:
					var directionR = (Vector2(section_position.x + 70, 0) - Vector2(position.x, 0)).normalized()
					velocity = directionR * speed
					if Vector2(position.x, 0).distance_to(Vector2(section_position.x + 70, 0)) < 5:
						repairMove = false
						repairing = true
						anim.play("repair")
					move_and_slide()

func State(nunmber):
	match(nunmber):
		1: #idle
			anim.play("idle")
			idle = true
			repairing = false
			checking = false
			speed = MaxSpeed/3
		2: #moving / jumping
			anim.play("walk")
			z_index = 2
			repairing = false
			repairMove = false
			operatorNum = 0
			idle = false
			checking = false
			speed = MaxSpeed
			print("walking")
		3: #attacking
			anim.play("attack")
			repairing = false
			checking = false
			print("attacking")
		4: #repearing
			if !repairing:
				repairMove = true
			idle = false
			checking = false
			z_index = 1
		5: #checking gun
			anim.play("check")
			checking = true
			repairing = false
			z_index = 1
			
			


func _on_section_walk_order():
	if selected:
		moving = true
		State(2)
