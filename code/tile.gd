class_name Tile
extends RefCounted


var walkable: bool = false
var walk_cost: int = 1
var description: String = ""
var title: String
var raised: PackedScene = null

#var tile_source: int = 0
#var atlas_coord: Vector2i

func _init(walk_cost: int, title: String, description: String) -> void:
	self.walkable = walk_cost >= 0
	self.walk_cost = walk_cost
	self.title = title
	self.description = description
	#self.tile_source = tile_source
	#self.atlas_coord = atlas_coord

func selectable() -> Selectable:
	var selectable: Selectable = Selectable.new()
	selectable.title = title
	selectable.description = description
	selectable.stats = {
		"walkable": walkable,
		"walk_cost": walk_cost
	}
	return selectable

	

#
#const GRASS = Tile.new()
#GRASS.walkable = true
#GRASS.walk_cost = 1
#GRASS.title = "Grass"
#GRASS.description = "An empty field"
#GRASS.atlas_coord = Vector2i(1, 0)
