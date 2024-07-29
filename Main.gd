extends Node2D

func _ready():
	var grid_scene = preload("res://GridCell.tscn")
	var grid = grid_scene.instantiate()
	add_child(grid)
	grid.position = Vector2(64, 64)  # Adjust position as needed
	
	var ship_scene = preload("res://Tower.tscn")
	var ship = ship_scene.instantiate()
	add_child(ship)
	ship.position = Vector2(700, 200)  # Initial position, adjust as needed
	
	var grid_container = grid.get_node("Control/GridContainer")
	ship.set_grid_container(grid_container)
