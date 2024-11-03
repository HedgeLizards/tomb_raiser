extends Node

signal selection_changed(selected: Selectable)


# Only one of selected_unit and selected_tile may be non-null at a time
var selected_unit: Node = null
var selected_tile: Tile = null
var selected_unit_walkable_tiles = null # only possible when selected_unit is not null
var selected_unit_action: ActionType = null # only possible when selected_unit is not null

const NOT_CLICKING: Vector2 = Vector2(-1_000_000, -1_000_000)
var click_start: Vector2 = NOT_CLICKING


func clear_select() -> void:
	selected_unit = null
	selected_tile = null
	selected_unit_walkable_tiles = null
	selected_unit_action = null
	%Selections.clear()

func select_none() -> void:
	clear_select()
	selection_changed.emit(null)

func select_unit(unit: Node) -> void:
	clear_select()
	selected_unit = unit
	print("selected ", unit.mappos, " ", unit)
	if unit.faction == unit.Faction.Undead:
		selected_unit_walkable_tiles = unit.walkable_tiles()
		for neighbour in selected_unit_walkable_tiles.keys():
			%Selections.set_cell(neighbour, 0, Vector2i.ZERO, 1)
	selection_changed.emit(unit.selectable())

func select_tile(tile: Tile, pos: Vector2i) -> void:
	clear_select()
	selected_tile = tile
	%Selections.clear()
	%Selections.set_cell(pos, 0, Vector2i.ZERO, 0)
	selection_changed.emit(tile.selectable())

func select_unit_action(action: ActionType) -> void:
	selected_unit_action = action
	%Selections.clear()
	for pos in selected_unit.targets(action):
		%Selections.set_cell(pos, 0, Vector2i.ZERO, 4)

func _unhandled_input(event: InputEvent) -> void:
	if not %Turn.can_interact():
		return
	var click_pos: Vector2
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			click_start = event.position
			return
		else:
			if event.position.distance_to(click_start) < 3:
				click_start = NOT_CLICKING
				click_pos = event.position
			else:
				click_start = NOT_CLICKING
				return
	else:
		return
	var clicked_tile: Vector2i = %Ground.local_to_map(%Ground.make_canvas_position_local(click_pos))
	tile_clicked(clicked_tile)

func tile_clicked(pos: Vector2i) -> void:
	var unit: Node2D = %Units.unit_at(pos)
	if selected_unit != null and selected_unit == unit:
		select_none()
		return
	if selected_unit and selected_unit.faction == selected_unit.Faction.Undead:
		if selected_unit_action != null:
			if selected_unit.can_act(selected_unit_action, pos):
				selected_unit.act(selected_unit_action, pos)
				if selected_unit.can_do_action():
					select_unit(selected_unit)
				else:
					select_none()
				return
		elif selected_unit_walkable_tiles.has(pos):
			selected_unit.walk_to(selected_unit_walkable_tiles[pos])
			if selected_unit.can_do_action():
				select_unit(selected_unit)
			else:
				select_none()
			return
	if unit != null:
		select_unit(unit)
		return
	var tile = %Ground.get_tile(pos)
	if tile != null:
		if %Selections.get_cell_alternative_tile(pos) == 0:
			select_none()
		else:
			select_tile(tile, pos)

func _on_ui_action_selected(action: ActionType) -> void:
	select_unit_action(action)
