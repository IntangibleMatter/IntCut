@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("CutsceneManager", "res://addons/IntCut/CutsceneManager.gd")
	add_autoload_singleton("CutsceneDisplay", "res://addons/IntCut/display/CutsceneDisplay.tscn")


func _exit_tree():
	remove_autoload_singleton("CutsceneManager")
	remove_autoload_singleton("CutsceneDisplay")
