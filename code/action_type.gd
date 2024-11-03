class_name AT
extends RefCounted

enum ActionType {Raise, Attack, Heal}

var type: ActionType

func _init(type: ActionType) -> void:
	self.type = type

static func cost(action: ActionType) -> int:
	if action == ActionType.Raise:
		return 2
	if action == ActionType.Attack:
		return 3
	if action == ActionType.Heal:
		return 2
	else:
		return 1_000_000

static func title(action: ActionType) -> String:
	if action == ActionType.Raise:
		return "Raise"
	if action == ActionType.Attack:
		return "Attack"
	if action == ActionType.Heal:
		return "Heal"
	else:
		return "No action"

#func can_perform(tile: Tile) -> bool:
	#return false
#
#func cost() -> int:
	#return 1_000_000
#
#class Raise extends ActionType:
	#func can_perform(tile: Tile) -> bool:
		#return tile.raised != null
	#
	#func cost() -> int:
		#return 2

#const Attack: ActionType = ActionType.new()
#const Raise: ActionType = ActionTYpe.new()
#const Heal: ActionType = ActionType.new()
