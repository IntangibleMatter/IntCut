extends Node2D

@export_node_path("Node2D") var actor

@onready var dialogue_bubble: Control = $CanvasLayer/DialogueBubble
@onready var camera_2d: Camera2D = $Camera2D
@onready var test_actor: Node2D = $TestActor

var speed = 400

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		test_actor.position.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		test_actor.position.y += speed * delta
	if Input.is_action_pressed("ui_left"):
		test_actor.position.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		test_actor.position.x += speed * delta
	
	prints("actor", test_actor.get_child(0).global_position, test_actor.get_child(0).get_rect())
