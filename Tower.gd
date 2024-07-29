extends Sprite2D

var is_dragging = false
var drag_offset = Vector2()
var grid_size = 128  # Size of each cell in the grid (same as the texture size)
var initial_pos = Vector2()

const GRID_DIMENSIONS = 3  # 3x3 grid

# Reference to the GridContainer node
var grid_container : GridContainer = null

func _ready():
	initial_pos = position
	if grid_container == null:
		print("Grid container is not set.")

func set_grid_container(container: GridContainer):
	grid_container = container
	if grid_container:
		print("Grid container assigned: ", grid_container.name)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_local_pos = to_local(event.position)
				if Rect2(Vector2.ZERO, Vector2(grid_size, grid_size)).has_point(mouse_local_pos):
					is_dragging = true
					drag_offset = global_position - event.global_position
					print("Started dragging. Drag offset: ", drag_offset)
					print("Initial global position: ", global_position)
			else:
				is_dragging = false
				snap_to_grid()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
		print("Dragging. Global position: ", global_position)

func snap_to_grid():
	if grid_container == null:
		print("Grid container is null")
		return

	# Convert global position to local position relative to the grid container
	var local_pos = global_position - grid_container.global_position
	print("Local Position before snapping: ", local_pos)

	# Calculate the nearest grid cell
	var snapped_x = clamp(round(local_pos.x / grid_size) * grid_size, 0, (GRID_DIMENSIONS - 1) * grid_size)
	var snapped_y = clamp(round(local_pos.y / grid_size) * grid_size, 0, (GRID_DIMENSIONS - 1) * grid_size)
	var snapped_local_pos = Vector2(snapped_x, snapped_y)
	print("Snapped Local Position: ", snapped_local_pos)

	# Convert snapped local position back to global position
	global_position = grid_container.global_position + snapped_local_pos
	print("Global Position after snapping: ", global_position)

	validate_position()

func validate_position():
	if grid_container == null:
		return

	# Convert global position to local position relative to the grid container
	var local_pos = global_position - grid_container.global_position
	var grid_x = round(local_pos.x / grid_size)
	var grid_y = round(local_pos.y / grid_size)

	# Ensure the ship is within grid bounds
	if grid_x < 0 or grid_y < 0 or grid_x >= GRID_DIMENSIONS or grid_y >= GRID_DIMENSIONS:
		print("Out of grid bounds, reverting to initial position")
		# Reset to initial position if out of bounds
		global_position = initial_pos
		return

	# Check for overlap with other ships
	var self_rect = Rect2(global_position, Vector2(grid_size, grid_size))
	for child in get_parent().get_children():
		if child != self:
			var child_pos = child.global_position
			var child_rect = Rect2(child_pos, Vector2(grid_size, grid_size))
			if child_rect.intersects(self_rect):
				print("Collision detected, reverting to initial position")
				global_position = initial_pos
				return

	# Update initial position to new snapped position
	initial_pos = global_position
