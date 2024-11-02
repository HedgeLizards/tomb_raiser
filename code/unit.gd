extends Sprite2D


signal select_pressed(unit: Node2D)

@export var tilemap: TileMapLayer

var mappos: Vector2i


func _ready() -> void:
	mappos = tilemap.local_to_map(position)
	position = tilemap.map_to_local(mappos)

func _on_texture_button_button_up() -> void:
	print("player clicked")
	select_pressed.emit(self)
