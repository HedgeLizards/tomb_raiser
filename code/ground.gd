extends TileMapLayer


var WATER: Tile = Tile.new(-1, "Water", "blub")
var GRASS: Tile = Tile.new(1, "Grass", "An empty field")
var MOUNTAIN: Tile = Tile.new(3, "Mountain", "A tall mountain")
var CEMETERY: Tile = Tile.new(1, "Cemetery", "A field of graves")
var TOMB: Tile = Tile.new(1, "Tomb", "The necromancer's lair")
var FOREST: Tile = Tile.new(2, "Forest", "A dense, spooky forest")
var VILLAGE: Tile = Tile.new(2, "Village", "An innocent village")


var tile_index = {
	Vector2i(0, 0): WATER,
	Vector2i(1, 0): GRASS,
	Vector2i(2, 0): MOUNTAIN,
	Vector2i(0, 1): TOMB,
	Vector2i(1, 1): CEMETERY,
	Vector2i(2, 1): FOREST,
	Vector2i(0, 2): VILLAGE
}

func get_tile(pos: Vector2i) -> Tile:
	if get_cell_source_id(pos) != 1:
		return null
	var tile = tile_index.get(get_cell_atlas_coords(pos))
	
	#print("tile ", tile, " ", get_cell_atlas_coords(pos))s
	return tile
	#var source = tile_set.get_source(get_cell_source_id(pos))
	##print("source ", source)
	#var scene = source.get_scene_tile_scene(get_cell_alternative_tile(pos))
	#print("scene ", scene)
	#print(scene.walkable)
	##print("cell  ", get_cell_alternative_tile(pos))
	#return null
