extends Sprite2D


@export var tilemap: TileMapLayer

var mappos: Vector2i


func _ready() -> void:
	print("unit ready")
	mappos = tilemap.local_to_map(position)
	position = tilemap.map_to_local(mappos)
