extends RigidBody2D

@export var left_wheel: RigidBody2D
@export var right_wheel: RigidBody2D

const WHEEL_FORCE = 500
const MAX_SPEED = 200
const TORQUE_FORCE = 100

func _physics_process(delta):
	var direction = 0

	if Input.is_action_pressed("ui_right"):
		direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction = -1

	if direction != 0:
		var force = Vector2(direction * WHEEL_FORCE, 0)
		left_wheel.apply_force(force)
		right_wheel.apply_force(force)
	
		apply_torque(direction * -TORQUE_FORCE)

	if left_wheel.linear_velocity.length() > MAX_SPEED:
		left_wheel.linear_velocity = left_wheel.linear_velocity.normalized() * MAX_SPEED
	if right_wheel.linear_velocity.length() > MAX_SPEED:
		right_wheel.linear_velocity = right_wheel.linear_velocity.normalized() * MAX_SPEED
