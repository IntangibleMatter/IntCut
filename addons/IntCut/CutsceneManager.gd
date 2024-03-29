extends Node

var icutils := IntCutUtils.new()

# store currently active cutscenes. { String cutscene_name : CutscenePlayer }
var cutscenes : Dictionary 


## This is from the old version of the cutsceme engine. Completely useless, but keeping it around just in case...
#func parse_cutscene(cutscene_name: String) -> Dictionary:
#	var scene_path := "res://assets/cutscenes/%s.cut.txt" % cutscene_name
#	prints("Trying to load cutscene script:", cutscene_name)
#	
#	if not FileAccess.file_exists(scene_path):
#		print("Couldn't load cutscene %s! File not found" % cutscene_name)
#		return {"start": [
#			["say", "game", "cutscene_load_error_1"],
#			["say", "game", "cutscene_load_error_2"]
#			]}
#	
#	var file = FileAccess.open(scene_path, FileAccess.READ)
#	var raw_scene = file.get_as_text()
#	
#	# split scene apart by labels
#	var split_scene = raw_scene.split("~")
#	
#	var labeled := {}
#	
#	for label in split_scene:
#		var lines := label.split("\n") # each part of the label split into lines
#		var title := lines[0] # title of the current label
#		lines.remove_at(0) # remove the label from the rest of the cutscene
#		var tokenized : Array[PackedStringArray] = [] # the lines tokenized 
#		for line in lines:
#			tokenized.append(line.split(" ")) # split the line apart and make it into individual tokens
#		
#		if not labeled.has(title):
#			labeled[title] = tokenized
#		else:
#			print_debug("Cutscene parser error: label name conflict {0} in cutscene {1}. Second item with name discarded".format([title, cutscene_name]))
#	
#	return labeled

