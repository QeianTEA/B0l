extends Area2D

@export var bullet_speed: float = 400.0 
var direction: Vector2 = Vector2() 

func _ready():
	# Connect the body_entered signal to detect collision with enemies
	connect("body_entered", Callable(self, "_on_body_entered"))


func _process(delta): # Move the bullet
	position += direction * bullet_speed * delta

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		# We need to implement logic when the bullet hits an enemy; destroy enemy, reduce health etc.
		queue_free()  # Destroy the bullet after it hits
