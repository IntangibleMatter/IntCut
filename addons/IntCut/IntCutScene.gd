class_name IntCutScene
extends Node

## Extend this class to write a cutscene. Just create a new script which begins
## with `extends IntCutScene`. That's it. Then just use the methods as directed,
## and work with great cutscenes!

var actors: Dictionary
signal scene_done()

## OVERRIDE THIS FUNCTION!!
## This function will be called at the beginning of a cutscene, and cutscenes
## expect to branch out from here. Just letting you know.
func start() -> void:
	end_scene()

## Allows a choice to be made by the player. Supports up to (TBD) options.
## The choice will be displayed in the order that they appear in the array.
## The dictionaries should be formatted as the following:
##
## { "title": "<translation_key>", "jump": "<function_to_jump_to>"}
func choice(choices: Array[Dictionary]) -> void:
	pass


func cinebars(enabled: bool) -> void:
	CutsceneDisplay.cinebars(enabled)


func say(actor: String, line: String, duration: float = -1): # duration is used for non-main cutscenes or interrupted dialogue.
	pass
	if verify_actor(actor):
#		var dialogue_continues : bool = next_say_is_by_actor(actor)
		# pass the dialogue along to the dialogue engine
#		if action.size() == 4:
		CutsceneDisplay.say(actors[actor], format_dialogue(line), duration)


		# We need to wait until the dialogue line is done so they don't just
		await CutsceneDisplay.dialogue_line_done


func format_dialogue(dialogue: String) -> String:
	var translated := tr(dialogue)
	translated.replace("\\n", "\n")
	return deal_with_vars("[center]" + translated)


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
		if actors[actor].is_instance_valid():
			if actor_states.has(actor):
				get_actor(actor).set_state(actor_states[actor])
			actor.set_state("Normal")
	emit_signal("scene_done")
	queue_free()


func verify_actor(actor: String) -> bool:
	if actors.has(actor):
		if actors[actor].is_instance_valid():
			return true

	# if the actor isn't valid, try and get it.
	var n : Node = get_tree().get_nodes_in_group(actor)[0]
	if n:
		n.set_state("cutscene")
		actors[actor] = n
		return true
	# i give up bro
	return false


func get_actor(actor: String) -> Node:
	if verify_actor(actor):
		return actors[actor]
	else:
		return null
