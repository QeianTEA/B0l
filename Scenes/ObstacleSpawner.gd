extends Node2D

@export var obstacle_scene: PackedScene  
@export var min_spawn_interval: float = 5.0  # Minimum time in seconds between spawns
@export var max_spawn_interval: float = 20.0  # Maximum time in seconds between spawns
@export var spawn_position: Vector2 = Vector2(400, 300)  # Fixed spawn position, in case we don't want to randomize
@export var spawn_offset: float = 1000.0
var viewport_size
var timer: float = 0.0
var obstacle

func _ready() -> void:
	# timer = randf_range(min_spawn_interval, max_spawn_interval)
	timer = 3
	viewport_size = get_viewport().size

func _process(delta: float) -> void:
	timer -= delta
	if !obstacle && timer <= 0:
		spawn_obstacle()
		# timer = randf_range(min_spawn_interval, max_spawn_interval)
		timer = 3
	if obstacle && obstacle.position.x < -viewport_size.x:  
		obstacle.queue_free()
		obstacle = null;
		print_debug("Clean")
func spawn_obstacle() -> void:
	obstacle = obstacle_scene.instantiate()
	# randf_range(50, get_viewport().size.y - 50)
	obstacle.position = Vector2(viewport_size.x + spawn_offset, spawn_position.y)  
	add_child(obstacle)
	print_debug("Spawned")
