extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Operators"):
		if body.idle:
			body.walkDirection *= -1
