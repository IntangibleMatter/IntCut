extends Node

var blackboard := {}


func get_blackboard_value(value: String) -> Variant:
	if blackboard.has(value):
		return blackboard[value]
	else:
		return 0
