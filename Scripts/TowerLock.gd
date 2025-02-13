extends Sprite2D

var is_dragging = false
var drag_offset = Vector2()
var grid_size = 128  # Size of each cell in the grid (should be same as the texture size)
@export var initial_pos = Vector2()

@export var level_started = false

@export var tower_width = 1  # Width of the tower in grid cells
@export var tower_height = 1  # Height of the tower in grid cells

@export var grid_position = Vector2(-1, -1)

var grid_container: GridContainer = null

func _ready():
	if !level_started:
		position = initial_pos
	
	if grid_container == null:
		print("Grid container is not set.")

func set_grid_container(container: GridContainer):
	grid_container = container
	if grid_container:
		print("Grid container assigned: ", grid_container.name)
	if level_started:  # If valid grid position is set
		snap_to_grid_using_position(grid_position)

func _input(event):
	if level_started:
		return  # Disable dragging if the level has started

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_local_pos = to_local(event.position)
				if Rect2(Vector2(-64 * tower_width, -64 * tower_height), Vector2(tower_width * grid_size, tower_height * grid_size)).has_point(mouse_local_pos):
					is_dragging = true
					drag_offset = global_position - event.global_position
					print("Started dragging. Drag offset: ", drag_offset)
			else:
				is_dragging = false
				snap_to_grid()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset

func snap_to_grid():
	if grid_container == null:
		print("Grid container is null")
		return

	var local_pos = global_position - grid_container.global_position
	print("Local Position before snapping: ", local_pos)

	# Snapping logic: Ensure positions are aligned to grid with tower size considered
	var snapped_x = round(local_pos.x / grid_size) * grid_size
	var snapped_y = round(local_pos.y / grid_size) * grid_size

	# Align based on tower size, so the tower's top-left corner aligns with the grid
	snapped_x = int(snapped_x) - int(snapped_x) % grid_size  # Align to grid based on width
	snapped_y = int(snapped_y) - int(snapped_y) % grid_size  # Align to grid based on height

	var grid_dimensions_x = grid_container.grid_columns
	var grid_dimensions_y = grid_container.grid_rows

	# Clamp the snapped position based on tower size and grid boundaries
	snapped_x = clamp(snapped_x, 0, (grid_dimensions_x - tower_width) * grid_size)
	snapped_y = clamp(snapped_y, 0, (grid_dimensions_y - tower_height) * grid_size)

	var snapped_local_pos = Vector2(snapped_x, snapped_y)
	print("Snapped Local Position: ", snapped_local_pos)

	global_position = grid_container.global_position + snapped_local_pos
	print("Global Position after snapping: ", global_position)

	# Save grid position (top-left corner)
	grid_position = Vector2(round(snapped_x / grid_size), round(snapped_y / grid_size))
	print("Saved grid position: ", grid_position)

	validate_position(local_pos)

func snap_to_grid_using_position(grid_pos: Vector2):
	if grid_container == null:
		print("Grid container is null")
		return

	# Convert grid position to local snapped position using top-left corner
	var snapped_local_pos = grid_pos * grid_size

	global_position = grid_container.global_position + snapped_local_pos
	print("Snapped to grid position: ", grid_pos)

func validate_position(local_pos):
	if grid_container == null:
		return

	var grid_x = round(local_pos.x / grid_size)
	var grid_y = round(local_pos.y / grid_size)

	var grid_dimensions_x = grid_container.grid_columns
	var grid_dimensions_y = grid_container.grid_rows

	if grid_x < 0 or grid_y < 0 or grid_x + tower_width > grid_dimensions_x or grid_y + tower_height > grid_dimensions_y:
		print("Out of grid bounds, reverting to initial position")
		global_position = initial_pos
		grid_position = Vector2(-1, -1)  # Reset grid position to invalid
		return

	var self_rect = Rect2(global_position, Vector2(tower_width * grid_size, tower_height * grid_size))
	for child in get_parent().get_children():
		if child != self and child is Sprite2D and child.has_meta("tower_width") and child.has("tower_height"):
			var child_pos = child.global_position
			var child_rect = Rect2(child_pos, Vector2(child.tower_width * grid_size, child.tower_height * grid_size))
			if child_rect.intersects(self_rect):
				print("Collision detected, reverting to initial position")
				global_position = initial_pos
				grid_position = Vector2(-1, -1)  # Reset grid position to invalid
				return

	initial_pos = global_position

func start_level():
	level_started = true  # Lock towers in place
	print("Level started. Towers locked in place.")

func reset_level():
	level_started = false  # Allow repositioning towers
	print("Level reset. Towers can be moved again.")
