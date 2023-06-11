extends Node2D

@export_node_path("Node2D") var actor

@onready var dialogue_bubble: Control = $CanvasLayer/DialogueBubble
@onready var camera_2d: Camera2D = $Camera2D
@onready var test_actor: Node2D = $TestActor

@onready var icutils := IntCutUtils.new()

var speed = 400

func _ready() -> void:
	add_child(icutils)

func _process(delta: float) -> void:
	queue_redraw()
	if Input.is_action_pressed("ui_up"):
		test_actor.position.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		test_actor.position.y += speed * delta
	if Input.is_action_pressed("ui_left"):
		test_actor.position.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		test_actor.position.x += speed * delta
	
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
	
	prints("actor", test_actor.get_child(0).global_position, test_actor.get_child(0).get_rect())
	prints("cam", camera_2d.position)


func _draw() -> void:
	var spr := icutils.get_actor_sprite(get_node(actor))
	var spr_rect := spr.get_rect()
	prints("sprect", spr_rect)
	var debug_points : PackedVector2Array = [
		spr.to_global(spr_rect.position),
		spr.to_global(spr_rect.position) + Vector2(spr_rect.size.x, 0),
		spr.to_global(spr_rect.position) + spr_rect.size,
		spr.to_global(spr_rect.position) + Vector2(0, spr_rect.size.y)
	]
	prints("dp", debug_points, spr.global_position - spr_rect.position)
	draw_colored_polygon(debug_points, Color(1, 0, 1, 0.5))
	draw_circle(spr.to_global(spr_rect.get_center()), 10, Color.DARK_GREEN)
