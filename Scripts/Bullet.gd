extends Area2D

@export var bullet_speed: float = 400.0 
var direction: Vector2 = Vector2() 
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
		
func set_miss(is_miss: bool):
	# Set the miss flag
	miss = is_miss
