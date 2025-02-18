extends TileMap

var astargrid = AStarGrid2D.new()
const main_layer = 0
const main_source = 1  #CHANGE
const path_taken_atlas_coords = Vector2i(2,4)  #CHANGE

const is_solid = "is_solid"

func _ready():
	setup_grid()


func setup_grid():
	astargrid.region = get_used_rect()
	astargrid.cell_size = Vector2i(40,40)  #EXPORT HERE FOR SIZE CHANGES
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()
	
	for cell in get_used_cells(main_layer):
		astargrid.set_point_solid(cell, is_spot_solid(cell))


func show_path(a,b):
	var path_taken = astargrid.get_id_path(Vector2i(1,1), Vector2i(3,1))
	for cell in path_taken:
		set_cell(main_layer, cell, main_source, path_taken_atlas_coords)


func is_spot_solid(spot_to_check:Vector2i) -> bool:
	return get_cell_tile_data(main_layer, spot_to_check).get_custom_data(is_solid)
