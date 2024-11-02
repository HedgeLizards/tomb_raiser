extends Node

var selected: Node = null
const NOT_CLICKING: Vector2 = Vector2(-1_000_000, -1_000_000)
var click_start: Vector2 = NOT_CLICKING

func _ready() -> void:
	print("cursor ready")

func select(unit: Node) -> void:
	# todo: validate selected
	self.selected = unit
	print("selected ", unit)
	print(unit.mappos)
	var neighbours: Array[Vector2i] = %Ground.get_surrounding_cells(unit.mappos)
	%Selections.clear()
	for neighbour in neighbours:
		%Selections.set_cell(neighbour, 0, Vector2i.ZERO, 1)
	print(neighbours)

func _unhandled_input(event: InputEvent) -> void:
	var click_pos: Vector2
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			click_start = event.position
			return
		else:
			if click_start == event.position:
				click_start = NOT_CLICKING
				click_pos = event.position
			else:
				click_start = NOT_CLICKING
				return
	elif event is InputEventScreenTouch:
		click_pos = event.position
	else:
		return
	print("mouse ", get_viewport().get_mouse_position())
	var clicked_tile: Vector2i = %Ground.local_to_map(%Ground.make_canvas_position_local(click_pos))
	var unit: Node2D = %Units.unit_at(clicked_tile)
	print("Input!!! " + str(click_pos) + " " + str(clicked_tile) + " " + str(unit))
	if unit != null:
		select(unit)
