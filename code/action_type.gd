class_name ActionType
extends RefCounted

var damage = -1

func can_perform(actor: Node, tile: Tile, unit: Node) -> bool:
	return false

func cost() -> int:
	return 1_000_000

func title() -> String:
	return "Unknown action"

func does_attack() -> bool:
	return false

func range() -> int:
	return 1

func healing() -> int: 
	return 0

class Raise extends ActionType:
	func can_perform(actor: Node, tile: Tile, unit: Node) -> bool:
		return tile.raised != null
	func range() -> int:
		return 1
	func cost() -> int:
		return 3
	func title() -> String:
		return "Raise Undead"
	func no_targets_nearby_reason() -> String:
		return "no bones in range"
class Attack extends ActionType:
	func _init(damage) -> void:
		self.damage = damage
	func can_perform(actor: Node, tile: Tile, unit: Node) -> bool:
		return unit != null and unit.faction != actor.faction
	func cost() -> int:
		return 1
	func does_attack():
		return true
	func range() -> int:
		return 1
	func title() -> String:
		return "Attack"
	func no_targets_nearby_reason() -> String:
		return "no humans in range"
class Heal extends ActionType:
	func can_perform(actor: Node, tile: Tile, unit: Node) -> bool:
		return false
	func cost() -> int:
		return 2
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
