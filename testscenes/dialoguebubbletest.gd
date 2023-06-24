extends Node2D

@export_node_path("Node2D") var actor

@onready var dialogue_bubble: Control = $CanvasLayer/DialogueBubble
@onready var camera_2d: Camera2D = $Camera2D
@onready var test_actor: Node2D = $TestActor

@onready var icutils := IntCutUtils.new()

#var bounding : Rect2

var speed = 400

func _ready() -> void:
	add_child(icutils)

func _process(delta: float) -> void:
#	queue_redraw()
	if Input.is_action_pressed("ui_up"):
		test_actor.position.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		test_actor.position.y += speed * delta
	if Input.is_action_pressed("ui_left"):
		test_actor.position.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		test_actor.position.x += speed * delta
	
	if Input.is_action_pressed("ui_accept"):
		test_actor.rotation -= delta
	elif Input.is_action_pressed("ui_cancel"):
		test_actor.rotation += delta
	
	if Input.is_action_pressed("w"):
		camera_2d.position.y -= speed * delta
	elif Input.is_action_pressed("s"):
		camera_2d.position.y += speed * delta
	if Input.is_action_pressed("a"):
		camera_2d.position.x -= speed * delta
	elif Input.is_action_pressed("d"):
		camera_2d.position.x += speed * delta
	
	if Input.is_action_pressed("ui_page_up"):
		camera_2d.zoom += Vector2(0.1, 0.1)
	elif Input.is_action_pressed("ui_page_down"):
		camera_2d.zoom -= Vector2(0.1, 0.1)
	
	if Input.is_action_just_pressed("ui_home"):
		dialogue_bubble.scale_dialogue_box()
	
#	prints("actor", test_actor.get_child(0).global_position, test_actor.get_child(0).get_rect())
#	prints("cam", camera_2d.position)
#
#
