extends Node

var selected: Node = null


func _ready() -> void:
	print("cursor ready")

func select(unit: Node) -> void:
	# todo: validate selected
	self.selected = unit
	print("selected ", unit)
	print(unit.mappos)
	var neighbours: Array[Vector2i] = %Ground.get_surrounding_cells(unit.mappos)
	%Selections.clear()
	for neighbour in neighbours:
		%Selections.set_cell(neighbour, 0, Vector2i.ZERO, 1)
	print(neighbours)


func _on_unit_select_pressed(unit: Node) -> void:
	select(unit)
