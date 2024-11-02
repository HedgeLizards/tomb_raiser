extends Node

signal selection_changed(selected: Selectable)


# Only one of selected_unit and selected_tile may be non-null at a time
var selected_unit: Node = null
var selected_tile: Tile = null

const NOT_CLICKING: Vector2 = Vector2(-1_000_000, -1_000_000)
var click_start: Vector2 = NOT_CLICKING


func clear_select() -> void:
	self.selected_unit = null
	self.selected_tile = null
	%Selections.clear()
	selection_changed.emit(null)

func select_unit(unit: Node) -> void:
	# todo: validate selected
	self.selected_unit = unit
	self.selected_tile = null
	%Selections.clear()
	print("selected ", unit.mappos, " ", unit)
	var walkable: Array[Vector2i]
	walkable.assign(unit.walkable_tiles().keys()) #%Ground.get_surrounding_cells(unit.mappos)
	for neighbour in walkable:
		%Selections.set_cell(neighbour, 0, Vector2i.ZERO, 1)
	#print(walkable)
	selection_changed.emit(unit.selectable())

func select_tile(tile: Tile) -> void:
	self.selected_unit = null
	self.selected_tile = null
	%Selections.clear()
	selection_changed.emit(tile.selectable())

func _unhandled_input(event: InputEvent) -> void:
	var click_pos: Vector2
	if event is InputEventMouseMotion:
		#print("mouse motion ", event.)
		click_start = NOT_CLICKING
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
	var clicked_tile: Vector2i = %Ground.local_to_map(%Ground.make_canvas_position_local(click_pos))
	tile_clicked(clicked_tile)

func tile_clicked(pos: Vector2i) -> void:
	if selected_unit:
		if pos == selected_unit.mappos:
			clear_select()
			return
		if selected_unit.can_walk_to(pos):
			selected_unit.walk_to(pos)
			if selected_unit.can_do_action():
				select_unit(selected_unit)
			else:
				clear_select()
			return
	var unit: Node2D = %Units.unit_at(pos)
	if unit != null:
		select_unit(unit)
		return
	var tile = %Ground.get_tile(pos)
	if tile != null:
		select_tile(tile)
