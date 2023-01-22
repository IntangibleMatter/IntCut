extends Node

var cutscene : Dictionary
var current_label : String
var action_index := 0

func play_next_action() -> void:
	var action : PackedStringArray = cutscene.current_label[action_index]


func format_dialogue(dialogue: String) -> String:
	var translated := tr(dialogue)
	
	return deal_with_vars(translated)


func deal_with_vars(v: String) -> String:
	var formatted : String
	
	var split_for_vars: PackedStringArray
	for line in v.split("{{"):
		split_for_vars.append_array(line.split("}}"))
	
	if split_for_vars.size() == 1:
		return split_for_vars[0]
	
	for i in range(split_for_vars.size()):
		if i % 2 == 0:
			formatted = formatted + split_for_vars[i]
		else:
			# TODO: replace `Global.get_blackboard_value` with whatever you use to store the game's data that's accessed in cutscenes.
			formatted = formatted + str(Global.get_blackboard_value(split_for_vars[i]))
	
	return formatted
