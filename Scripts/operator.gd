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
		#var direction = (Vector2(section_position.x + 40 , 0) - Vector2(position.x, 0)).normalized()
		#velocity = direction * speed
		#if Vector2(position.x, 0).distance_to(Vector2(section_position.x + 40, 0)) < 5:
		#	moving = false
		#move_and_slide()
		return
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

func move_operator(operator, path):
	moving = true
	State(2)  # Set the state to "walking"
	
	for tile in path:
		var target_position = tile_to_world(tile)
		while position.distance_to(target_position) > 5:  # Adjust tolerance as needed
			var direction = (target_position - position).normalized()
			velocity = direction * speed
			move_and_slide()
			await (get_tree().create_timer(0.01))  # Small delay to make movement smooth
		
		# Snap operator to the exact tile position after each step
		position = target_position
		await (get_tree().create_timer(0.1))  # Add a slight delay before moving to the next tile
	
	# Path completed
	moving = false
	State(1)  # Set state to "idle" when the path is complete

func tile_to_world(tile: Vector2) -> Vector2:
	# Assuming each tile is a fixed size (e.g., 64x64)
	return Vector2(tile.x * 64, tile.y * 64)

func world_to_tile(world_position: Vector2) -> Vector2:
	# Convert world position to grid position (tile-based)
	return Vector2(floor(world_position.x / 64), floor(world_position.y / 64))

func tile(grid_position: Vector2) -> Vector2:
	# Convert a position to the tile grid system
	return world_to_tile(grid_position)


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

@onready var gameScript = get_tree().root.get_node("GameScene")

func _on_section_walk_order():
	var start_tile = tile(position)
	var target_tile = world_to_tile(section_position)
	var path = gameScript.find_path(start_tile, target_tile)
		
	if path.size() > 0 && selected:
		gameScript.move_operator(self, path)
		moving = true
		State(2)
	else:
		print("No valid path to target!")
