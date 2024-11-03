extends Node2D

func _enter_tree() -> void:
	for child in get_children():
		child.tilemap = %Ground
		child.units = self

func reset_turn() -> void:
	for child in get_children():
		child.reset_turn();

func unit_at(pos: Vector2i):
	for unit in get_children():
		if unit.mappos == pos:
			return unit

func add_unit(pos: Vector2i, to_raise: PackedScene) -> void:
	var unit: Node = to_raise.instantiate()
	unit.mappos = pos
	unit.position = %Ground.map_to_local(pos)
	unit.tilemap = %Ground
	unit.units = self
	add_child(unit)

func show_effect(pos: Vector2i, effect: Control) -> void:
	effect.position = %Ground.map_to_local(pos)
	%Effects.add_child(effect)

func run_enemy_turn() -> void:
	var units: Array[Node] = get_children().filter(func (unit): return unit.faction == unit.Faction.Human)
	units.shuffle()
	for unit in units:
		enemy_unit_turn(unit)

func enemy_unit_turn(unit: Node) -> void:
		var opponent: WalkStep = unit.nearest_opponent()
		if opponent == null:
			# todo: walk random
			return
		var path: Array[WalkStep] = opponent.path()
		while unit.action_points > 0:
			var actions = unit.actions.filter(func (action): return action.does_attack())
			for action in actions:
				print("enemy action", action, " ", unit, " ", opponent, " ", opponent.pos, " ", unit.can_act(action, opponent.pos))
				if unit.can_act(action, opponent.pos):
					unit.act(action, opponent.pos)
					return
			var target: WalkStep = path.pop_front()
			while target != null and unit_at(target.pos) != null:
				target = path.pop_front()
			if target == null:
				return
			unit.walk_to(target)
			
