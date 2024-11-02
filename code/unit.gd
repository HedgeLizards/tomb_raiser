extends Node2D


@export var actions: Array[AT.ActionType]

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

func reset_turn() -> void:
	action_points = max_action_points

func can_walk_to(pos: Vector2i) -> bool:
	return walkable_tiles().has(pos)

func walk_to(pos: Vector2i) -> void:
	var cost: int = walkable_tiles()[pos].cost
	action_points -= cost
	mappos = pos
	# todo: animation
	position = tilemap.map_to_local(mappos)

func can_do_action() -> bool:
	return action_points > 0


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
	visited.erase(mappos)
	return visited

func targets(action: AT.ActionType) -> Array[Vector2i]:
	#return []
	if AT.cost(action) > action_points:
		return []
	return tilemap.get_surrounding_cells(mappos).filter(func(pos): return can_act(action, pos))

func can_act(action: AT.ActionType, pos: Vector2i) -> bool:
	if not (action in actions):
		return false
	if action == AT.ActionType.Raise:
		#print(pos, " ", tilemap.get_tile(pos).raised != null, tilemap.get_tile(pos).title)
		return tilemap.get_tile(pos).raised != null
	else:
		return false

func act(action: AT.ActionType, pos: Vector2i):
	if action == AT.ActionType.Raise:
		var to_raise: PackedScene = tilemap.get_tile(pos).raised
		var unit: Node = to_raise.instantiate()
		unit.mappos = pos
		unit.position = tilemap.map_to_local(pos)
		unit.tilemap = tilemap
		get_parent().add_child(unit)
		print("raised the dead")

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
	selectable.actions = []
	for action in actions:
		var sa: Selectable.Action = Selectable.Action.new()
		var cost = AT.cost(action)
		sa.stats = {"action_cost": cost}
		sa.enabled = true
		sa.title = AT.title(action)
		print(sa.title, " ", targets(action))
		if cost > action_points:
			sa.enabled = false
			sa.disabled_reason = "Not enough action points"
		elif targets(action).size() == 0:
			sa.enabled = false
			sa.disabled_reason = "No available target nearby"
		selectable.actions.push_back(sa)
			
	#var attackAction: Selectable.Action = Selectable.Action.new()
	#attackAction.title = "Attack"
	#attackAction.enabled = false
	#attackAction.disabled_reason = "no enemies in range"
	#attackAction.stats = {"action_cost": 3}
	#selectable.actions = [attackAction]
	return selectable
	
