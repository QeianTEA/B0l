extends Area2D

@export var bullet_speed: float = 400.0 
@export var explosion_radius: float = 100.0
@export var explode_in_air: bool = false
@export var fuse_time: float = 1.5

var direction: Vector2 = Vector2() 
var fuse_timer: Timer
var miss: bool = false

func _ready():
	# Connect the body_entered signal to detect collision with enemies
	connect("body_entered", Callable(self, "_on_body_entered"))
		
func _process(delta): # Move the bullet
	position += direction * bullet_speed * delta

func _on_body_entered(body):
	if !miss && body.is_in_group("Enemy"): # if we deem the hit as a miss no collision happens with any enemy, we may change this behaviour
		# We need to implement logic when the bullet hits an enemy; destroy enemy, reduce health etc.
		queue_free()  # Destroy the bullet after it hits
	if !miss && explode_in_air:
		explode()
			
func set_miss(is_miss: bool):
	miss = is_miss

func start_fuse_timer():
	if explode_in_air:
		fuse_timer = Timer.new()
		fuse_timer.wait_time = fuse_time
		fuse_timer.one_shot = true
		add_child(fuse_timer)
		fuse_timer.connect("timeout", Callable(self, "_explode_in_air"))
		fuse_timer.start()  # Start the timer when the bullet is shot
		
func _explode_in_air():
	explode()

func explode():
	print("Boom! Bullet exploded.")
	# Get all enemies in explosion radius
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= explosion_radius:
			# Apply damage or destroy the enemy
			print("Enemy hit by explosion")
	queue_free()
