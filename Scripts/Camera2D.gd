extends Camera2D

var mousePos = Vector2()

@onready var panel = %DrawBox

var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false

signal area_selected

@warning_ignore("unassigned_variable", "unused_parameter")

func _ready():
	operators = get_tree().get_nodes_in_group("Operators")

func _process(_delta):
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
	
	if isDragging:
		end = mousePosGlobal
		endV= mousePos
		draw_area()
	
	if Input.is_action_just_released("LeftClick"):
		# if startV.distance_to((mousePos) > 20):
		end = mousePosGlobal
		endV = mousePos
		emit_signal("area_selected",self)
		# else:
		end = start
		
		isDragging = false
		draw_area(false)

func _input(event):
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()


func draw_area(s = true):
	panel.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	panel.position = pos
	panel.size *= int(s)

var operators = []

@warning_ignore("unassigned_variable", "unused_parameter")

func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area = []
	
	area.append(Vector2(min(start.x,end.x), min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x), max(start.y,end.y)))
	
	var ut = get_units_in_area(area)
	for u in operators:
		u.set_selected(false)
	for u in ut:
		u.set_selected(!u.selected)

func get_units_in_area(area):
	var u = []
	for unit in operators:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				u.append(unit)
				pass
	return u
