extends Node2D

@export var parent: Sprite2D
@export var obstacle_scene: PackedScene  
@export var min_spawn_interval: float = 5.0  # Minimum time in seconds between spawns
@export var max_spawn_interval: float = 20.0  # Maximum time in seconds between spawns
@export var spawn_position: Vector2 = Vector2(400, 300)  # Fixed spawn position, in case we don't want to randomize
@export var spawn_offset: float = 20.0
var viewport_size
var timer: float = 0.0
var obstacle
var obstacle_sprite
var obstacle_size: Vector2

func _ready() -> void:
	# timer = randf_range(min_spawn_interval, max_spawn_interval)
	timer = 3
	viewport_size = get_viewport().size

func _process(delta: float) -> void:
	#if obstacle:
	timer -= delta
	#if !obstacle && timer <= 0:
	if  !obstacle && timer <= 0:
		spawn_obstacle()
		# timer = randf_range(min_spawn_interval, max_spawn_interval)
		timer = 3
	if obstacle && obstacle.global_position.x < (parent.global_position.x - viewport_size.x/2 - obstacle_size.x):
		obstacle.queue_free()
		obstacle = null;
		print_debug("Clean")
func	spawn_obstacle() -> void:
	obstacle = obstacle_scene.instantiate()
	if obstacle_size.x == 0:
		obstacle_sprite = obstacle.get_node("Sprite2D")
		if obstacle_sprite and obstacle_sprite.texture:
			obstacle_size = obstacle_sprite.texture.get_size() * obstacle_sprite.scale
	# randf_range(50, get_viewport().size.y - 50)
	obstacle.global_position = Vector2(parent.global_position.x + viewport_size.x/2 + spawn_offset + obstacle_size.x, spawn_position.y)  
	add_child(obstacle)
	print_debug("Spawned, %f", obstacle.position.x)
