extends Sprite2D


@export var tilemap: TileMapLayer
@export var title: String
@export var max_health: int
@export var max_action_points: int

var mappos: Vector2i
@onready var action_points = max_action_points
@onready var health = max_health


func _ready() -> void:
	mappos = tilemap.local_to_map(position)
	position = tilemap.map_to_local(mappos)

func can_walk_to(pos: Vector2i) -> bool:
	return walkable_tiles().has(pos)

func walk_to(pos: Vector2) -> void:
	mappos = pos
	# todo: animation
	position = tilemap.map_to_local(mappos)

func can_do_action() -> bool:
	# todo: action points
	return true


class WalkTile:
	var pos: Vector2i
	var cost: int
	func _init(p: Vector2i, c: int) -> void:
		self.pos = p
		self.cost = c

func walkable_tiles() -> Dictionary:
	var start = Time.get_ticks_msec()
	var frontier: Array[WalkTile] = [WalkTile.new(mappos, 0)]
	var visited: Dictionary = {}
	while frontier.size() > 0:
		var tile: WalkTile = frontier.pop_front()
		var old: WalkTile = visited.get(tile.pos)
		if old != null and old.cost <= tile.cost:
			continue
		
		visited[tile.pos] = tile
		for neighbour: Vector2i in tilemap.get_surrounding_cells(tile.pos):
			var tiledata: Tile = tilemap.get_tile(neighbour)
			if tiledata and tiledata.walkable:
				var cost: int = tile.cost + tiledata.walk_cost
				if cost <= action_points:
					frontier.push_back(WalkTile.new(neighbour, cost))
	var end = Time.get_ticks_msec()
	return visited

func selectable() -> Selectable:
	#todo: get these value from actual unit
	var selectable: Selectable = Selectable.new()
	selectable.title = title
	selectable.stats = {
		"max_action_points": max_action_points,
		"action_points": action_points,
		"max_health": max_health,
		"health": health
	}
	var attackAction: Selectable.Action = Selectable.Action.new()
	attackAction.title = "Attack"
	attackAction.enabled = false
	attackAction.disabled_reason = "no enemies in range"
	attackAction.stats = {"action_cost": 3}
	selectable.actions = [attackAction]
	return selectable
	
