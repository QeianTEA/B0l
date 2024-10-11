extends Node2D

@export var BULLET: PackedScene = null  # Bullet scene
@export var bullet_speed: float = 600.0 
@export var reload_time: float = 0.1  # Time it takes to reload after each shot
@export var reload_ammo_time: float = 3.0  # Time to reload the entire ammo once out
@export var max_ammo: int = 60
@export var max_range: float = 650.0 

@export var explosion_radius: float = 100.0
@export var explode_in_air: bool = false
@export var fuse_time: float = 1.5

var target: Node2D = null 
var current_ammo: int
var is_reloading: bool = false  

@onready var gunSprite = $GunSprite
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer
@onready var ammoReloadTimer = Timer.new()  

func _ready():
	current_ammo = max_ammo  
	reloadTimer.wait_time = reload_time  
	ammoReloadTimer.wait_time = reload_ammo_time  
	ammoReloadTimer.one_shot = true  
	add_child(ammoReloadTimer)  
	ammoReloadTimer.connect("timeout", Callable(self, "_on_ammoReloadTimer_timeout"))  # Moved to _ready to avoid multiple connections
	await get_tree().process_frame
	target = find_target()


func _physics_process(_delta): 
	if target != null and not is_reloading:  
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		var distance_to_target = global_position.distance_to(target.global_position)

		if distance_to_target > max_range:  
			target = find_target()  
			return

		rayCast.target_position = Vector2(distance_to_target, 0).rotated(angle_to_target)
		rayCast.global_rotation = angle_to_target

		if rayCast.get_collider() and rayCast.is_colliding() and rayCast.get_collider().is_in_group("Enemy"):
			gunSprite.rotation = angle_to_target
			if reloadTimer.time_left == 0 and current_ammo > 0:
				shoot()
@export var miss_chance: float = 0.1  # 10% chance to miss by default
@export var miss_angle_deviation: float = PI / 12  # Deviation of 15 degrees (adjust as needed)

func shoot():
	print("PEW! Shooting bullet.")
	rayCast.enabled = false

	if BULLET:
		var bullet: Area2D = BULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.explosion_radius = explosion_radius
		bullet.explode_in_air = explode_in_air
		bullet.fuse_time = fuse_time
		# Calculate the bullet's direction
		var bullet_direction = Vector2(1, 0).rotated(rayCast.global_rotation)

		# Implement chance to miss
		var rand = randi() % 100 / 100.0
		var is_miss = false
		if rand < miss_chance: # Random chance for turret to aim a few degrees away from the enemy
			print("Missed!")
			var miss_offset = randf_range(-miss_angle_deviation, miss_angle_deviation)
			bullet_direction = bullet_direction.rotated(miss_offset)  # Adjust direction slightly
			is_miss = true;
		bullet.set_miss(is_miss)
		bullet.global_rotation = bullet_direction.angle()
		bullet.direction = bullet_direction  
		
		bullet.start_fuse_timer()
		
	reloadTimer.start()
	current_ammo -= 1
	print("Ammo left: ", current_ammo)

	if current_ammo <= 0:
		start_reloading()





func start_reloading():
	print("Out of ammo! Reloading...")
	is_reloading = true  
	ammoReloadTimer.start()  


func _on_ammoReloadTimer_timeout():
	print("Ammo reloaded!")
	current_ammo = max_ammo  
	is_reloading = false  
	rayCast.enabled = true  


func find_target():
	var new_target: Node2D = null
	var closest_distance: float = INF  
	
	if get_tree().has_group("Enemy"):
		var enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_distance and distance <= max_range:  
				closest_distance = distance
				new_target = enemy as Node2D
	
	return new_target


func _on_ReloadTimer_timeout():
	rayCast.enabled = true
