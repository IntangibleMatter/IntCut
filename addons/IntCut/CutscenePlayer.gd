class_name CutscenePlayer
extends Node

var cutscene_name : String
var cutscene : Dictionary
var current_label : String
var action_index := 0
var actors : Dictionary

signal scene_done(scene_name: String)

func setup(scene_name: String, scene : Dictionary) -> void:
	cutscene_name = scene_name
	cutscene = scene


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

func end_scene(actor_states: Dictionary = {}) -> void:
	for actor in actors:
		if actor.is_instance_valid():
			if actor_states.has(actor):
				actor.set_state(actor_states[actor])
			actor.set_state("Normal")
	emit_signal("scene_done", cutscene_name)
	queue_free()


func handle_action(action: PackedStringArray) -> void:
	match action[0]:
		"say":
			pass
		"play":
			pass
		"move":
			pass
		"tween":
			pass
		"sound":
			pass
		"jump":
			pass
		"music":
			pass
		"screenshake":
			pass
		"move_camera":
			pass
