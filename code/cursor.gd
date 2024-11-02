extends Node

var selected: Node = null

func _ready() -> void:
	print("cursor ready")

func select(selected_unit: Node) -> void:
	# todo: validate selected
	self.selected = selected_unit
	var pos: Vector2i = %Selections.local_to_map(selected_unit.position)


func _on_unit_select_pressed(unit: Node) -> void:
	print("selected ", unit)
	#select(unit)
