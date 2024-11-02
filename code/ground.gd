extends TileMapLayer



class Tile:
	var walkable: bool
	var walk_cost: int
	var description: String
	var title: String
	
	func selectable() -> Selectable:
		return Selectable.new(
			title,
			description,
			{
				walkable: true,
				walk_cost: walk_cost
			},
			[]
		)


	


func get_tile(pos: Vector2i) -> Tile:
	return null
