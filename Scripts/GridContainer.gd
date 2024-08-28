extends GridContainer

const CELL_SIZE = 128

# Exported properties to set grid dimensions from the editor
@export var grid_columns = 3
@export var grid_rows = 3

func _ready():
	for y in range(grid_rows):
		for x in range(grid_columns):
			var cell = create_cell(x, y)
			add_child(cell)

func create_cell(x, y):
	var cell = Sprite2D.new()
	cell.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	cell.texture = preload("res://icon.svg")  # Add a texture for visual representation
	return cell
