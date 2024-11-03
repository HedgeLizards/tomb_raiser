class_name WalkStep
extends RefCounted

var cost: int
var pos: Vector2i
var previous: WalkStep
func _init(pos: Vector2i, cost: int, previous: WalkStep = null) -> void:
	self.pos = pos
	self.cost = cost
	self.previous = previous

func path() -> Array[WalkStep]:
	if previous == null:
		return [self]
	var p: Array[WalkStep] = previous.path()
	p.push_back(self)
	return p
