class_name Selectable
extends RefCounted

var title: String
var description: String
var stats: Dictionary # Dictionary[String, int]
var actions: Array[Action] # only for units

func _init(title: String, description: String, stats: Dictionary, actions: Array[Action]) -> void:
	self.title = title
	self.description = description
	self.stats = stats
	self.actions = actions

class Action:
	var title: String
	var is_disabled: bool
	var disabled_reason: String # only if is_disabled
	var stats: Dictionary # Dictionary[String, int]