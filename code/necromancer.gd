extends Sprite2D


signal select_pressed(unit: Node2D)

@export var tilemap: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = tilemap.map_to_local(tilemap.local_to_map(position))


func _on_texture_button_button_up() -> void:
	print("player clicked")
	select_pressed.emit(self)
