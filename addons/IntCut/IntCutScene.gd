class_name IntCutScene
extends Node

## Extend this class to write a cutscene. Just create a new script which begins
## with `extends IntCutScene`. That's it. Then just use the methods as directed,
## and work with great cutscenes!

var actors: Dictionary
var icutils := IntCutUtils.new()
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

## `actor` is the string which is used to reference the actor.
## `line` is the translation key of the string that's sent to the dialogue
## box.
## `continues` denotes whether the dialogue bubble should close or stay open 
## to help make dialogue look smoother... so prone to breaking tho. Defaults
## to false.
## `pos` should use a flag from DialogueBubble.POS_FLAGS to denote any special
## position information.
## `duration` is used to automatically advance dialogue after a certain amount
## of time. If it's -1 (the default) it'll stay open indefinitely.
func say(actor: String, line: String, continues: bool = false, pos: int = 0, duration: float = -1): # duration is used for non-main cutscenes or interrupted dialogue.
	pass
	if verify_actor(actor):
#		var dialogue_continues : bool = next_say_is_by_actor(actor)
		# pass the dialogue along to the dialogue engine
#		if action.size() == 4:
		CutsceneDisplay.say(actors[actor], format_dialogue(line), continues, pos, duration)


		# We need to wait until the dialogue line is done so they don't just
		await CutsceneDisplay.dialogue_line_done

func format_dialogue(dialogue: String) -> String:
	return "center" + icutils.format_text(dialogue)


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


func jump(label: String) -> void:
	var callable := Callable(self, label)
	if callable.is_valid():
		callable.call()
	else:
		return