extends Node2D

func _ready():
	var grid_scene = preload("res://GridCell.tscn")
	var grid = grid_scene.instantiate()
	add_child(grid)
	grid.position = Vector2(64, 64)  # Adjust position as needed
	
	var tower1_scene = preload("res://Tower1.tscn")
	var tower1 = tower1_scene.instantiate()
	add_child(tower1)
	tower1.position = Vector2(700, 200)  # Initial position, adjust as needed
	
	var tower2_scene = preload("res://Tower2.tscn")
	var tower2 = tower2_scene.instantiate()
	add_child(tower2)
	tower2.position = Vector2(700, 600)  # Initial position, adjust as needed
	
	var grid_container = grid.get_node("Control/GridContainer")
	tower1.set_grid_container(grid_container)
	tower2.set_grid_container(grid_container)
