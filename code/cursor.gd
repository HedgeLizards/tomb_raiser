extends Node

var selected: Node = null


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
	if event is InputEventMouseButton and event.pressed:
		click_pos = event.global_position
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
