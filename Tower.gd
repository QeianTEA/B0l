extends Sprite2D

var is_dragging = false
var drag_offset = Vector2() 
var grid_size = 128  # Size of each cell in the grid (make sure this matches CELL_SIZE in GridContainer)
var initial_pos = Vector2()

const GRID_DIMENSIONS = 3  # 3x3 grid

# Reference to the GridContainer node
var grid_container = null

func _ready():
	initial_pos = position
	# Get the GridContainer node
	grid_container = get_tree().get_root().get_node("GridContainer")  # Adjust path as necessary

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_rect().has_point(to_local(event.position)):
					is_dragging = true
					drag_offset = global_position - event.global_position  
			else:
				is_dragging = false
				snap_to_grid() 
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			rotation_degrees += 90 

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset  # Follow the mouse cursor

func snap_to_grid():
	if grid_container == null:
		return
	
	# Convert global position to local position relative to the grid container
	var local_pos = grid_container.to_local(global_position)
	
	# Snap to the nearest grid cell
	local_pos.x = round(local_pos.x / grid_size) * grid_size
	local_pos.y = round(local_pos.y / grid_size) * grid_size
	
	# Convert back to global position
	global_position = grid_container.to_global(local_pos)
	
	validate_position()

func validate_position():
	if grid_container == null:
		return
	
	var local_pos = grid_container.to_local(global_position)
	var grid_x = round(local_pos.x / grid_size)
	var grid_y = round(local_pos.y / grid_size)

	if grid_x < 0 or grid_y < 0 or grid_x >= GRID_DIMENSIONS or grid_y >= GRID_DIMENSIONS:
		# Reset to initial position if out of bounds
		global_position = initial_pos
		return
		
	for child in get_parent().get_children():
		if child != self and child.get_rect().intersects(get_rect()):
			global_position = initial_pos  # Reset to initial position if overlapping
			return
	
	# Update initial position to the new snapped position
	initial_pos = global_position
