extends Node2D

func _ready():
	var grid_scene = preload("res://Scenes/GridCell.tscn")
	var grid = grid_scene.instantiate()
	add_child(grid)
	grid.position = Vector2(120, 192)  # Adjust position as needed
	

	
	var tower2_scene = preload("res://Scenes/TowerLocked2.tscn")
	var tower2 = tower2_scene.instantiate()
	add_child(tower2)
	tower2.position = tower2.initial_pos  
	

	
	var grid_container = grid.get_node("Control/GridContainer")

	tower2.set_grid_container(grid_container)

