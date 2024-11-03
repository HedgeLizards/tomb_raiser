class_name ActionType
extends RefCounted

var strength = -1

func can_perform(tile: Tile, unit: Node) -> bool:
	return false

func cost(_action_points: int) -> int:
	return 1_000_000

func title() -> String:
	return "Unknown action"

class Raise extends ActionType:
	func can_perform(tile: Tile, unit: Node) -> bool:
		return tile.raised != null
	func range() -> int:
		return 1
	func cost(_action_points: int) -> int:
		return 3
	func damage(_action_points: int) -> int:
		return 0
	func healing() -> int:
		return 0
	func title() -> String:
		return "Raise Undead"
	func no_targets_nearby_reason() -> String:
		return "no bones in range"
class Attack extends ActionType:
	func _init(strength) -> void:
		self.strength = strength
	func can_perform(tile: Tile, unit: Node) -> bool:
		return unit != null and unit.faction == unit.Faction.Human
	func cost(action_points: int) -> int:
		return max(action_points, 1)
	func damage(action_points: int) -> int:
		return action_points * strength
	func healing() -> int:
		return 0
	func range() -> int:
		return 1
	func title() -> String:
		return "Attack"
	func no_targets_nearby_reason() -> String:
		return "no humans in range"
class Heal extends ActionType:
	func can_perform(tile: Tile, unit: Node) -> bool:
		return false
	func cost(_action_points: int) -> int:
		return 2
	func damage(_action_points: int) -> int:
		return 0
	func healing() -> int:
		return 2
	func range() -> int:
		return 2
	func title() -> String:
		return "Heal Undead"
	func no_targets_nearby_reason() -> String:
		return "no undead in range"
	
	
	#if action == ActionType.Raise:
		#return 2
	#if action == ActionType.Attack:
		#return 3
	#if action == ActionType.Heal:
		#return 2
	#else:
		#return 1_000_000
#
#static func title(action: ActionType) -> String:
	#if action == ActionType.Raise:
		#return "Raise"
	#if action == ActionType.Attack:
		#return "Attack"
	#if action == ActionType.Heal:
		#return "Heal"
	#else:
		#return "No action"

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
