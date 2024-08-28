extends Sprite2D

var is_dragging = false
var drag_offset = Vector2()
var grid_size = 128  # Size of each cell in the grid (same as the texture size)
@export var initial_pos = Vector2()

# Exported properties to set tower dimensions from the editor
@export var tower_width = 1  # Width of the tower in grid cells
@export var tower_height = 1  # Height of the tower in grid cells

@export var offset_x = 0
@export var offset_y = 0

var grid_container: GridContainer = null

func _ready():
	position = initial_pos
	
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
				if Rect2(Vector2(-64 * tower_width,-64 * tower_height), Vector2(tower_width * grid_size, tower_height * grid_size)).has_point(mouse_local_pos):
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
	# var local_pos = initial_pos
	print("Local Position before snapping: ", local_pos)

	# Calculate the nearest grid cell
	var snapped_x = floor(local_pos.x / grid_size) * grid_size
	var snapped_y = floor(local_pos.y / grid_size) * grid_size

	
	#snapped_y += offset_y
	#snapped_x += offset_x
	
	# Get grid dimensions from the container
	var grid_dimensions_x = grid_container.grid_columns
	var grid_dimensions_y = grid_container.grid_rows

	# Ensure the snapped position is within the grid bounds, taking tower size into account
	snapped_x = clamp(snapped_x, 0, (grid_dimensions_x - tower_width) * grid_size)
	snapped_y = clamp(snapped_y, 0, (grid_dimensions_y - tower_height) * grid_size)
	
	snapped_y += offset_y
	snapped_x += offset_x
	
	# Final snapped position taking into account the tower's size
	var snapped_local_pos = Vector2(snapped_x, snapped_y)
	print("Snapped Local Position: ", snapped_local_pos)

	# Convert snapped local position back to global position
	global_position = grid_container.global_position + snapped_local_pos
	print("Global Position after snapping: ", global_position)

	validate_position(local_pos)




func validate_position(local_pos):
	if grid_container == null:
		return

	# Convert global position to local position relative to the grid container
	#var local_pos = global_position - grid_container.global_position
	var grid_x = round(local_pos.x / grid_size)
	var grid_y = round(local_pos.y / grid_size)

	# Get grid dimensions from the container
	var grid_dimensions_x = grid_container.grid_columns
	var grid_dimensions_y = grid_container.grid_rows

	# Ensure the tower is within grid bounds
	if grid_x < 0 - offset_x or grid_y < 0 - offset_y or grid_x + tower_width > grid_dimensions_x + offset_x or grid_y + tower_height > grid_dimensions_y + offset_y:
		print("Out of grid bounds, reverting to initial position")
		# Reset to initial position if out of bounds
		global_position = initial_pos
		#position = initial_pos
		#local_pos = initial_pos
		return

	# Check for overlap with other towers
	var self_rect = Rect2(global_position, Vector2(tower_width * grid_size - offset_x, tower_height * grid_size - offset_y))
	for child in get_parent().get_children():
		if child != self and child is Sprite2D:
			var child_pos = child.global_position
			var child_rect = Rect2(child_pos, Vector2(child.tower_width * grid_size - child.offset_x, child.tower_height * grid_size - child.offset_y))
			if child_rect.intersects(self_rect):
				print("Collision detected, reverting to initial position")
				global_position = initial_pos
				#position = initial_pos
				#local_pos = initial_pos
				return

	# Update initial position to new snapped position
	initial_pos = global_position
