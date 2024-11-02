extends TileMapLayer



class Tile:
	var walkable: bool
	var walk_cost: int
	var description: String
	var title: String
	
	func selectable() -> Selectable:
		var selectable: Selectable = Selectable.new()
		selectable.title = title
		selectable.description = description
		selectable.stats = {
			walkable: true,
			walk_cost: walk_cost
		}
		return selectable


	


func get_tile(pos: Vector2i) -> Tile:
	return null
