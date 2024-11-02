extends Node2D

func _enter_tree() -> void:
	
	for child in get_children():
		child.tilemap = %Ground


func unit_at(pos: Vector2i):
	for unit in get_children():
		if unit.mappos == pos:
			return unit
