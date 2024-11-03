extends TileMapLayer


var WATER: Tile = Tile.new(-1, "Water", "A deep body of water. Impossible to traverse.")
var GRASS: Tile = Tile.new(1, "Grassland", "An open area. Easy to traverse.")
var MOUNTAIN: Tile = Tile.new(3, "Mountain", "A tall mountain. Difficult to traverse.")
var CEMETERY: Tile = Tile.new(1, "Cemetery", "A burial ground. The necromancer can raise an undead army here, which will decay each turn.", {"raised": preload("res://scenes/units/skeleton.tscn")})
var TOMB: Tile = Tile.new(1, "Tomb", "The resting place of the necromancer. Once a legendary emperor, nowadays his legacy is all but forgotten. He hath risen to take back his lands.")
var FOREST: Tile = Tile.new(2, "Forest", "A dense forest.")
var VILLAGE: Tile = Tile.new(2, "Village", "A frightened village. Spawns a human army every X turns, until razed to the ground.")


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
	
	return tile

func distance_between(a: Vector2i, b: Vector2i) -> int:
	assert(tile_set.tile_layout == TileSet.TileLayout.TILE_LAYOUT_STAIRS_RIGHT)
	# https://www.redblobgames.com/grids/hexagons/#distances-axial
	var d = b - a
	var r = d.x
	var q = d.y
	return (abs(q) + abs(r) + abs(r + q)) / 2
	
