extends Node

signal selection_changed(selected: Selectable)


# Only one of selected_unit and selected_tile may be non-null at a time
var selected_unit: Node = null
var selected_tile: Tile = null
var selected_unit_action: AT = null # only possible when selected_unit is not null

const NOT_CLICKING: Vector2 = Vector2(-1_000_000, -1_000_000)
var click_start: Vector2 = NOT_CLICKING


func clear_select() -> void:
	selected_unit = null
	selected_tile = null
	selected_unit_action = null
	%Selections.clear()

func select_none() -> void:
	clear_select()
	selection_changed.emit(null)

func select_unit(unit: Node) -> void:
	clear_select()
	selected_unit = unit
	print("selected ", unit.mappos, " ", unit)
	var walkable: Array[Vector2i]
	walkable.assign(unit.walkable_tiles().keys()) #%Ground.get_surrounding_cells(unit.mappos)
	for neighbour in walkable:
		%Selections.set_cell(neighbour, 0, Vector2i.ZERO, 1)
	#print(walkable)
	selection_changed.emit(unit.selectable())

func select_tile(tile: Tile) -> void:
	clear_select()
	selected_tile = tile
	%Selections.clear()
	selection_changed.emit(tile.selectable())

func select_unit_action(action: AT.ActionType) -> void:
	self.selected_unit_action = AT.new(action)
	%Selections.clear()

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
	var unit: Node2D = %Units.unit_at(pos)
	if selected_unit != null and selected_unit == unit:
		select_none()
		return
	if unit != null:
		select_unit(unit)
		return
	if selected_unit:
		if selected_unit_action != null:
			if selected_unit.can_act(selected_unit_action.type, pos):
				selected_unit.act(selected_unit_action.type, pos)
				if selected_unit.can_do_action():
					select_unit(selected_unit)
				else:
					select_none()
				return
		elif selected_unit.can_walk_to(pos):
			selected_unit.walk_to(pos)
			if selected_unit.can_do_action():
				select_unit(selected_unit)
			else:
				select_none()
			return
	var tile = %Ground.get_tile(pos)
	if tile != null:
		select_tile(tile)


func _on_ui_action_selected(action: AT.ActionType) -> void:
	selected_unit_action = AT.new(action)
