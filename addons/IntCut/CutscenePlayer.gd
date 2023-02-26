class_name CutscenePlayer
extends Node

var cutscene_name : String
var cutscene : Dictionary
var current_label : String
var action_index := 0
var actors : Dictionary

signal scene_done(scene_name: String)
signal action_done


func setup(scene_name: String, scene : Dictionary) -> void:
	cutscene_name = scene_name
	cutscene = scene


func cutscene_loop() -> void:
	while not action_index == cutscene[current_label].size():
		play_next_action()
		await self.action_done
		action_index += 1
	
	end_scene()


func play_next_action() -> void:
	var action : PackedStringArray = cutscene.current_label[action_index]
	handle_action(action)


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


func verify_actor(actor: String) -> bool:
	if actors.has(actor):
		if actors[actor].is_instance_valid():
			return true
		else:
			return false
	else:
		var n : Node = get_tree().current_scene.get_node("%" + actor)
		if n:
			n.set_state("cutscene")
			actors[actor] = n
			return true
	
	return false


# This is the backbone of what actually plays the cutscenes. It uses a match statement to
# call other nodes and other functions to do whatever it needs to. 
# If you want to change or add functionality, this is where you want to look 9 times out of 10.
func handle_action(action: PackedStringArray) -> void:
	match action[0]:
		"choice": # [choice first_choice, label_to_jump_to_on_first_choice, second choice, label_to_jump_to_on_second_choice, ...]
			pass
		"cinebars": # [cinebars enabled]
			CutsceneDisplay.cinebars(action[1])
		"if": # [if, value_name, (=, <, >, !=), (value_name, value), label, ("var", "abs")=absolute]
			if action.size() == 6:
				handle_if(action[1], action[2], action[3], action[4], action[5])
			else:
				handle_if(action[1], action[2], action[3], action[4])
		"jump": # [jump, label]
			handle_jump(action[1])
				# next_action
		"move": # [move, actor, duration, x, y, ("relative", "absolute")="absolute", easing=0 (in), transition=0 (linear), relative_to=actor]
			match action.size():
				6:
					# set movement_type
					pass
				7:
					# set movement_type, easing
					pass
				8: 
					# set movement_type, easing, transition
					pass
				9:
					# set movement_type, easing, transition, relative_to
					pass
				_:
					# set duration, x, y. All other settings default
					pass
		"move_camera":
			pass
		"music":
			pass
		"play": # [play, actor, animation, duration, speed=1]
			# pass the instructions along to the
			pass
		"say": # [say, actor, line, duration=-1] # duration is used for non-main cutscenes or interrupted dialogue.
			if verify_actor(action[1]):
				var dialogue_continues : bool = next_say_is_by_actor(action[1])
				# pass the dialogue along to the dialogue engine
				if action.size() == 4:
					CutsceneDisplay.say(actors[action[1]], format_dialogue(action[2]), dialogue_continues, float(action[3]))
				else:
					CutsceneDisplay.say(actors[action[1]], format_dialogue(action[2]), dialogue_continues)
				
				# We need to wait until the dialogue line is done so they don't just
				await CutsceneDisplay.dialogue_line_done
		"screenshake":
			pass
		"set": # [set, value_name, value]
			pass
		"sound":
			pass
		"tween":
			pass
		"wait": # [wait, wait_time]
			await get_tree().create_timer(float(action[1]))
	
	emit_signal("action_done")


func handle_jump(label) -> void:
	if cutscene.has(label):
				current_label = label
				action_index = 0


func handle_if(value_name : String, equivelance : String, comp_value: String, jump: String, comp_type = "abs") -> void:
	var val : Variant = Global.get_blackboard_value(value_name)
	var cval : Variant = Global.get_blackboard_value(comp_value) if comp_type == "var" else comp_value
	
	var output : bool
	
	match equivelance:
		">":
			output = float(val) > float(cval)
		"<":
			output = float(val) < float(cval)
		"=":
			output = str(val) == str(cval)
	
	if output:
		handle_jump(jump)


func next_say_is_by_actor(actor: String) -> bool:
	var currlab : PackedStringArray = cutscene[current_label]
	for i in range(action_index + 1, cutscene[current_label].size()):
		if currlab[i][0] == "say":
			if currlab[i][1] == actor:
				return true
			else:
				return false
		elif currlab[i][0] == "wait":
			return false
	
	return false
