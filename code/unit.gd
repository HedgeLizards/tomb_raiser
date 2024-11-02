extends Sprite2D


@export var tilemap: TileMapLayer

var mappos: Vector2i


func _ready() -> void:
	print("unit ready")
	mappos = tilemap.local_to_map(position)
	position = tilemap.map_to_local(mappos)



func can_walk_to(pos: Vector2i) -> bool:
	return pos in tilemap.get_surrounding_cells(mappos)

func walk_to(pos: Vector2) -> void:
	mappos = pos
	# todo: animation
	position = tilemap.map_to_local(mappos)

func can_do_action() -> bool:
	# todo: action points
	return true
