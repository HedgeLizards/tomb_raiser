extends TileMapLayer


var WATER: Tile = Tile.new(-1, "Water", "~~~~~")
var GRASS: Tile = Tile.new(1, "Grass", "An empty field")
var MOUNTAIN: Tile = Tile.new(2, "Grass", "A tall mountain")


var tile_index = {
	Vector2(0, 0): WATER,
	Vector2(0, 1): GRASS,
	Vector2(0, 2): MOUNTAIN
}

func get_tile(pos: Vector2i) -> Tile:
	if get_cell_source_id(pos) != 1:
		return null
	var tile = tile_index.get(get_cell_atlas_coords(pos))
	print("tile ", tile)
	return tile_index.get(get_cell_atlas_coords(pos))
	#var source = tile_set.get_source(get_cell_source_id(pos))
	##print("source ", source)
	#var scene = source.get_scene_tile_scene(get_cell_alternative_tile(pos))
	#print("scene ", scene)
	#print(scene.walkable)
	##print("cell  ", get_cell_alternative_tile(pos))
	#return null
