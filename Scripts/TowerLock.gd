extends Sprite2D

var is_dragging = false
var drag_offset = Vector2()
var grid_size = 128  # Size of each cell in the grid (should be same as the texture size)
@export var initial_pos = Vector2()

@export var level_started = false 


@export var tower_width = 1  # Width of the tower in grid cells
@export var tower_height = 1  # Height of the tower in grid cells

@export var offset_x = 0
@export var offset_y = 0

@export var grid_position = Vector2(-1, -1)

var grid_container: GridContainer = null

func _ready():

	#if grid_position != Vector2(-1, -1):  # If valid grid position is set
	#	snap_to_grid_using_position(grid_position)
	
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

	var snapped_x = floor(local_pos.x / grid_size) * grid_size
	var snapped_y = floor(local_pos.y / grid_size) * grid_size
	
	snapped_y += offset_y
	snapped_x += offset_x
	
	var grid_dimensions_x = grid_container.grid_columns
	var grid_dimensions_y = grid_container.grid_rows

	snapped_x = clamp(snapped_x, 0, (grid_dimensions_x - tower_width) * grid_size)
	snapped_y = clamp(snapped_y, 0, (grid_dimensions_y - tower_height) * grid_size)

	var snapped_local_pos = Vector2(snapped_x, snapped_y)
	print("Snapped Local Position: ", snapped_local_pos)

	global_position = grid_container.global_position + snapped_local_pos
	print("Global Position after snapping: ", global_position)

	# Save grid position
	grid_position = Vector2(snapped_x / grid_size, snapped_y / grid_size)
	print("Saved grid position: ", grid_position)

	validate_position(local_pos)

func snap_to_grid_using_position(grid_pos: Vector2):
	if grid_container == null:
		print("Grid container is null")
		return

	# Convert grid position to local snapped position
	var snapped_local_pos = grid_pos * grid_size
	snapped_local_pos.x += offset_x
	snapped_local_pos.y += offset_y

	# Convert snapped local position to global position
	global_position = grid_container.global_position + snapped_local_pos
	print("Snapped to grid position: ", grid_pos)

func validate_position(local_pos):
	if grid_container == null:
		return

	var grid_x = round(local_pos.x / grid_size)
	var grid_y = round(local_pos.y / grid_size)

	var grid_dimensions_x = grid_container.grid_columns
	var grid_dimensions_y = grid_container.grid_rows

	if grid_x < 0 - offset_x or grid_y < 0 - offset_y or grid_x + tower_width > grid_dimensions_x + offset_x or grid_y + tower_height > grid_dimensions_y + offset_y:
		print("Out of grid bounds, reverting to initial position")
		global_position = initial_pos
		grid_position = Vector2(-1, -1)  # Reset grid position to invalid
		return

	var self_rect = Rect2(global_position, Vector2(tower_width * grid_size - offset_x, tower_height * grid_size - offset_y))
	for child in get_parent().get_children():
		if child != self and child is Sprite2D:
			var child_pos = child.global_position
			var child_rect = Rect2(child_pos, Vector2(child.tower_width * grid_size - child.offset_x, child.tower_height * grid_size - child.offset_y))
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
