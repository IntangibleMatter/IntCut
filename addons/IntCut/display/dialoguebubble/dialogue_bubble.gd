class_name DialogueBubble
extends Control

enum POS_FLAGS {DEFAULT, FORCE_TOP, FORCE_BOTTOM}

var times : float = 0

var scaled := false

var text_position := 0 #stores the position in the dialogue bubble
var text_string_positon := 0 # Stores the position in the text string to deal with delays and the like

var bubble_rect: Rect2
var bubble_origin_points : PackedVector2Array

var corner_points_template : PackedVector2Array = [
	Vector2(-1.5, 2.5),
	Vector2(-0.5, 0.5),
	Vector2(0.5, -0.5),
	Vector2(2.5, -1.5)
]
var corner_scale : float = 16

@export var speaker: Node2D
@export var pos_flag : POS_FLAGS

@onready var rich_text_label = $RichTextLabel
@onready var icutils := IntCutUtils.new()

func _ready() -> void:
	bubble_rect = Rect2(calculate_bubble_location(), Vector2.ZERO)
	rich_text_label.text = """[shake rate=20 level=5]You...
Was this [shake rate=40 level=20]your[/shake] doing?[/shake]"""
	waittt()

func waittt() -> void:
	await get_tree().create_timer(4)
	print("GOOO")
	scale_dialogue_box()

func _process(delta) -> void:
	if not scaled:
		times += delta


func scale_dialogue_box() -> void:
	var start_size : Vector2 = rich_text_label.size
	var line_height := start_size.y/4
	print(line_height)
	
	for i in range(3):
		prints("y", rich_text_label.size)
		rich_text_label.size.y -= line_height
		await get_tree().process_frame
		if rich_text_label.size.y < start_size.y:
			start_size.y = rich_text_label.size.y
		else:
			break
	
#	var one_line : bool = rich_text_label.size.y < line_height*2
	
	for i in range(4):
		prints(4, rich_text_label.size)
		rich_text_label.size.x /= 2
		await get_tree().process_frame
		if rich_text_label.size.y > start_size.y:
#			if not one_line:
			rich_text_label.size.x *= 2
#			if one_line:
#				start_size.y = rich_text_label.size.y
			start_size.x = rich_text_label.size.x
			await get_tree().process_frame
			rich_text_label.size.y = start_size.y
			break
	
	await get_tree().process_frame
	
	for i in range(7):
		prints(3, rich_text_label.size)
		var curr_size : float = rich_text_label.size.x
		rich_text_label.size.x -= floor(rich_text_label.size.x/8)
		await get_tree().process_frame
		if rich_text_label.size.y > start_size.y:
			rich_text_label.size.x += floor(curr_size/8)
			start_size.x = rich_text_label.size.x
			await get_tree().process_frame
			rich_text_label.size.y = 0
			break
	
	scaled = true
	
	var tween := create_tween()
	tween.tween_property(self, "bubble_rect", Rect2(Vector2.ZERO, rich_text_label.size), 0.2)
	
	print(times)


func final_text_format(txt: String) -> String:
	# this bit of code will make it so that you the text can easily be made more accessible.
	# Modify for however you do settings, and more wherever the fonts are.
#	if Settings.override_text_format:
#		#strip out all font change tags from txt
#		if Settings.override_text_font == "OpenDyslexic":
#			txt = "[font=\"res://assets/fonts/OpenDyslexic-Regular.otf\"]" + txt
#		elif Settings.override_text_font == "Hyperlegible":
#			txt = "[font=\"res://assets/fonts/Atkinson-Hyperlegible-Regular-102.otf\"]" + txt
	return txt


func calculate_bubble_location() -> Vector2:
	var pos : Vector2 = icutils.get_actor_top_center(speaker)
	if pos_flag == POS_FLAGS.FORCE_BOTTOM or pos.y > icutils.get_cam_center().y:
		# put the dialogue box in the bottom half of the screen
		pass
	else:
		# put the dialogue box in the top half of the screen
		pass
	return pos


func draw_bubble() -> void:
	pass


func rotate_and_scale_bubble_corner(turns: int) -> PackedVector2Array:
	var corner : PackedVector2Array = corner_points_template
	match turns % 4:
		0:
			pass
		1: # flip h
			for point in corner.size():
				corner[point].x = -corner[point].x
		2: # flip h and v
			for point in corner.size():
				corner[point].x = -corner[point].x
				corner[point].y = -corner[point].y
		3: # flip v
			for point in corner.size():
				corner[point].y = -corner[point].y
	return []
