extends RigidBody2D

@export var wheel1: RigidBody2D
@export var wheel2: RigidBody2D
@export var wheel3: RigidBody2D
@export var wheel4: RigidBody2D

const WHEEL_FORCE = 2000
const MAX_SPEED = 1600
const TORQUE_FORCE = 1000

func _physics_process(delta):
	var direction = 0

	if Input.is_action_pressed("ui_right"):
		direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction = -1

	if direction != 0:
		var force = Vector2(direction * WHEEL_FORCE, 0)
		wheel1.apply_force(force)
		wheel2.apply_force(force)
		wheel3.apply_force(force)
		wheel4.apply_force(force)
	
		apply_torque(direction * -TORQUE_FORCE)

	if wheel1.linear_velocity.length() > MAX_SPEED:
		wheel2.linear_velocity = wheel1.linear_velocity.normalized() * MAX_SPEED
	if wheel2.linear_velocity.length() > MAX_SPEED:
		wheel2.linear_velocity = wheel2.linear_velocity.normalized() * MAX_SPEED
	if wheel3.linear_velocity.length() > MAX_SPEED:
		wheel3.linear_velocity = wheel3.linear_velocity.normalized() * MAX_SPEED
	if wheel4.linear_velocity.length() > MAX_SPEED:
		wheel4.linear_velocity = wheel4.linear_velocity.normalized() * MAX_SPEED
