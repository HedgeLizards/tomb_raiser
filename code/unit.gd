extends Node2D

enum RawActionType {Raise, AttackWeak, Heal}
@export var raw_actions: Array[RawActionType]

var tilemap: TileMapLayer
var units: Node2D
@export var title: String
@export var max_health: int
@export var max_action_points: int
enum Faction {Undead, Human}
@export var faction: Faction
var AttackEffect = preload("res://scenes/effects/attack_effect.tscn")
var HealEffect = preload("res://scenes/effects/heal_effect.tscn")

var mappos: Vector2i
@onready var action_points = max_action_points
@onready var health = max_health
@onready var actions = raw_actions.map(parse_action)


static func parse_action(action: RawActionType) -> ActionType:
	if action == RawActionType.Raise:
		return ActionType.Raise.new()
	elif action == RawActionType.Heal:
		return ActionType.Heal.new()
	elif action == RawActionType.AttackWeak:
		return ActionType.Attack.new(1)
	else:
		return null

func _ready() -> void:
	mappos = tilemap.local_to_map(position)
	position = tilemap.map_to_local(mappos)

func reset_turn() -> void:
	action_points = max_action_points

func walk_to(last_step: WalkStep) -> void:
	action_points -= last_step.cost
	mappos = last_step.pos
	var tween = create_tween()
	var previous_position: Vector2
	for step in last_step.path():
		var next_position: Vector2 = tilemap.map_to_local(step.pos)
		if step.previous == null:
			previous_position = next_position
			continue
		tween.tween_callback(func(): scale.x = abs(scale.x) * sign(previous_position.x - next_position.x))
		tween.tween_property(self, "position", next_position, 0.3)
		previous_position = next_position

func can_do_action() -> bool:
	return action_points > 0


func nearest_opponent() -> WalkStep:
	var has_opponent = func (tile):
		var unit = units.unit_at(tile.pos)
		return unit != null and unit.faction != faction
	return _search_tiles(100, has_opponent)

func walkable_tiles() -> Dictionary:
	var walkable = {}
	_search_tiles(action_points, func(tile): walkable[tile.pos] = tile)
	for unit in units.get_children():
		walkable.erase(unit.mappos)
	return walkable

func _search_tiles(max_distance: int, callback: Callable):
	var start = Time.get_ticks_msec()
	var frontier: Array[WalkStep] = [WalkStep.new(mappos, 0)]
	var visited: Dictionary = {}
	while frontier.size() > 0:
		var step: WalkStep = frontier.pop_front()
		var pos = step.pos
		var old: WalkStep = visited.get(pos)
		if old != null and old.cost <= step.cost:
			continue
		
		visited[step.pos] = step
		if callback.call(step):
			return step
		for neighbour: Vector2i in tilemap.get_surrounding_cells(step.pos):
			var tiledata: Tile = tilemap.get_tile(neighbour)
			if tiledata and tiledata.walkable:
				var cost: int = step.cost + tiledata.walk_cost
				if cost <= max_distance:
					frontier.push_back(WalkStep.new(neighbour, cost, step))
	

func targets(action: ActionType) -> Array[Vector2i]:
	#return []
	if action.cost(action_points) > action_points:
		return []
	var in_range: Array[Vector2i] = [mappos]
	for _i in action.range():
		for j in in_range.size():
			for neighbour: Vector2i in tilemap.get_surrounding_cells(in_range[j]):
				if not in_range.has(neighbour):
					in_range.push_back(neighbour)
	return in_range.filter(func(pos): return can_act(action, pos))

func can_act(action: ActionType, pos: Vector2i) -> bool:
	if action in actions and tilemap.distance_between(mappos, pos) <= action.range():
		return action.can_perform(self, tilemap.get_tile(pos), units.unit_at(pos))
	else:
		return false

func act(action: ActionType, pos: Vector2i):
	if is_instance_of(action, ActionType.Raise):
		var to_raise: PackedScene = tilemap.get_tile(pos).raised
		get_parent().add_unit(pos, to_raise)
	if is_instance_of(action, ActionType.Attack):
		var enemy = units.unit_at(pos)
		var damage: int = min(action.damage(action_points), enemy.health)
		enemy.health -= damage
		var effect = AttackEffect.instantiate()
		effect.set_text(str(damage))
		get_parent().show_effect(pos, effect)
		if enemy.health == 0:
			enemy.queue_free()
	if is_instance_of(action, ActionType.Heal):
		var ally = units.unit_at(pos)
		var healing: int = min(action.healing(), ally.max_health - ally.health)
		ally.health += healing
		var effect = HealEffect.instantiate()
		effect.set_text(str(healing))
		get_parent().show_effect(pos, effect)
	action_points -= action.cost(action_points)

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
	if faction == Faction.Undead:
		selectable.stats["faction"] = "Undead"
	elif faction == Faction.Human:
		selectable.stats["Faction"] = "Human"
	else:
		selectable.stats["Faction"] = "Unknown"
	selectable.actions = []
	for action in actions:
		var sa: Selectable.Action = Selectable.Action.new()
		var cost: int = action.cost(action_points)
		var damage: int = action.damage(action_points)
		var healing: int = action.healing()
		sa.type = action
		sa.stats = {"action_cost": cost, "range": action.range()}
		if damage > 0:
			sa.stats.damage = damage
		if healing > 0:
			sa.stats.healing = healing
		sa.enabled = true
		sa.title = action.title()
		if faction != Faction.Undead:
			sa.enabled = false
			sa.disabled_reason = "not under your control"
		elif cost > action_points:
			sa.enabled = false
			sa.disabled_reason = "not enough action points"
		elif targets(action).size() == 0:
			sa.enabled = false
			sa.disabled_reason = action.no_targets_nearby_reason()
		selectable.actions.push_back(sa)
			
	#var attackAction: Selectable.Action = Selectable.Action.new()
	#attackAction.title = "Attack"
	#attackAction.enabled = false
	#attackAction.disabled_reason = "no enemies in range"
	#attackAction.stats = {"action_cost": 3}
	#selectable.actions = [attackAction]
	return selectable
	
