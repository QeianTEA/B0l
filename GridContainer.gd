extends GridContainer

const GRID_SIZE = 3
const CELL_SIZE = 128

func _ready():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell = create_cell(x, y)
			add_child(cell)

func create_cell(x, y):
	var cell = Sprite2D.new()
	cell.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	cell.texture = preload("res://icon.svg")  # Add a texture for visual representation
	return cell
