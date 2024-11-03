class_name ActionType
extends RefCounted


func can_perform(tile: Tile) -> bool:
	return false

func cost() -> int:
	return 1_000_000

func title() -> String:
	return "Unknown action"

class Raise extends ActionType:
	func can_perform(tile: Tile) -> bool:
		return tile.raised != null
	func cost() -> int:
		return 2
	func title() -> String:
		return "Raise"
class Attack extends ActionType:
	func can_perform(tile: Tile) -> bool:
		return false
	func cost() -> int:
		return 1
	func title() -> String:
		return "Attack"
class Heal extends ActionType:
	func can_perform(tile: Tile) -> bool:
		return false
	func cost() -> int:
		return 2
	func title() -> String:
		return "Heal"

enum RawActionType {Raise, Attack, Heal}

static func from_raw(action: RawActionType) -> ActionType:
	if action == RawActionType.Raise:
		return Raise.new()
	elif action == RawActionType.Heal:
		return Heal.new()
	elif action == RawActionType.Attack:
		return Attack.new()
	else:
		return null
	
	
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
