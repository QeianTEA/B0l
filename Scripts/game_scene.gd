extends Node2D

#var operators = []
#
#@warning_ignore("unassigned_variable", "unused_parameter")
#
#func _ready():
	#operators = get_tree().get_nodes_in_group("Operators")
#
#func _on_area_selected(object):
	#var start = object.start
	#var end = object.end
	#var area = []
	#
	#area.append(Vector2(min(start.x,end.x), min(start.y,end.y)))
	#area.append(Vector2(max(start.x,end.x), max(start.y,end.y)))
	#
	#var ut = get_units_in_area(area)
	#for u in operators:
		#u.set_selected(false)
	#for u in ut:
		#u.set_selected(!u.selected)
#
#func get_units_in_area(area):
	#var u = []
	#for unit in operators:
		#if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			#if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				#u.append(unit)
				#pass
	#return u

#@export var grid = [
	#[1, 1, 1],
	#[1, 0, 1],
	#[1, 0, 1],
	#] # Your 2D grid representing the map (1 = tile, 0 = hole)
#var directions = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)] # Up, Down, Left, Right
#
#func find_path(start: Vector2, target: Vector2) -> Array:
	#if grid[target.y][target.x] == 0:
		#return [] # No path if target is a hole
	#
	#var queue = []
	#var visited = []
	#var paths = {}
	#
	#queue.append(start)
	#visited.append(start)
	#paths[start] = [start]
	#
	#while queue.size() > 0:
		#var current = queue.pop_front()
		#
		#if current == target:
			#return paths[current]
		#
		#for direction in directions:
			#var neighbor = current + direction
			#
			## Check bounds and validity
			#if neighbor.x >= 0 and neighbor.x < grid[0].size() and neighbor.y >= 0 and neighbor.y < grid.size():
				#if grid[neighbor.y][neighbor.x] == 1 and not visited.has(neighbor):
					#visited.append(neighbor)
					#queue.append(neighbor)
					#paths[neighbor] = paths[current] + [neighbor]
	#
	#return [] # No path found

#func move_operator(operator, path):
	## Implement operator movement along the path
	#for tile in path:
		#await(get_tree().create_timer(0.5)) # Wait before each move
		#operator.position = tile_to_world(tile) # Convert tile to world position and move operator

#func tile_to_world(tile: Vector2) -> Vector2:
	## Assuming each tile is a fixed size (e.g., 64x64)
	#return Vector2(tile.x * 64, tile.y * 64)


