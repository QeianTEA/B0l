extends Sprite2D

@export var tank_speed: float = 30.0 

var direction: Vector2 = Vector2(1, 0) 

	
func _process(delta):
	position += direction * tank_speed * delta
