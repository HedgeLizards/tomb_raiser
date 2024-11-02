extends Sprite2D


@export var tilemap: TileMapLayer

var mappos: Vector2i
var walk_range = 5 # todo: base on unit type / action points


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
		if tile.cost < walk_range:
			for neighbour: Vector2i in tilemap.get_surrounding_cells(tile.pos):
				#tile = tilemap.get
				frontier.push_back(WalkTile.new(neighbour, tile.cost + 1))
	var end = Time.get_ticks_msec()
	return visited

func selectable() -> Selectable:
	#todo: get these value from actual unit
	var selectable: Selectable = Selectable.new()
	selectable.title = "Skeleton"
	selectable.stats = {"action_points": 10, "health": 3}
	var attackAction: Selectable.Action = Selectable.Action.new()
	attackAction.title = "Attack"
	attackAction.enabled = false
	attackAction.disabled_reason = "no enemies in range"
	attackAction.stats = {"action_cost": 3}
	selectable.actions = [attackAction]
	return selectable
	
