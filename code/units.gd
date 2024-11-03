extends Node2D

func _enter_tree() -> void:
	for child in get_children():
		child.tilemap = %Ground
		child.units = self

func reset_turn() -> void:
	for child in get_children():
		child.reset_turn();

func unit_at(pos: Vector2i):
	for unit in get_children():
		if unit.mappos == pos:
			return unit

func add_unit(pos: Vector2i, to_raise: PackedScene) -> void:
	var unit: Node = to_raise.instantiate()
	unit.mappos = pos
	unit.position = %Ground.map_to_local(pos)
	unit.tilemap = %Ground
	unit.units = self
	add_child(unit)
