extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Operators"):
		if body.idle:
			body.walkDirection = Vector2(-body.walkDirection.x, 0)
