class_name DialogueBubble
extends Control

enum POS_FLAGS {DEFAULT, FORCE_TOP, FORCE_BOTTOM}

var scaled := false

var text_position := 0 #stores the position in the dialogue bubble
var text_string_positon := 0 # Stores the position in the text string to deal with delays and the like

var bubble_rect: Rect2
var bubble_points_base : PackedVector2Array # points which displayed bubble is based on. Doesn't change.
var bubble_points : PackedVector2Array # Displayed points. Updates.
var bubble_colour := Color.BLACK

var corner_points_template : PackedVector2Array = [
	Vector2(-1.5, 2.5),
	Vector2(-0.5, 0.5),
	Vector2(0.5, -0.5),
	Vector2(2.5, -1.5)
]
var corner_scale : float = 1

@export var text : PackedStringArray
@export var speaker: Node2D
@export var pos_flag : POS_FLAGS

@export var bubble_corner_size := 1
@export var bubble_point_move_scale := 2
@export var bubble_padding := 16

@onready var rich_text_label = $RichTextLabel
@onready var icutils := IntCutUtils.new()

func _ready() -> void:
	bubble_rect = Rect2(calculate_bubble_location(), Vector2.ZERO)
	calculate_bubble_points(bubble_rect)
	rich_text_label.text = """[center]Hi"""
	waittt()

func _process(delta: float) -> void:
	update_bubble_points(delta)
	update_speech_line()
	queue_redraw()

func waittt() -> void:
	await get_tree().create_timer(4)
	print("GOOO")
	scale_dialogue_box()


func scale_dialogue_box() -> void:
	rich_text_label.size.x = rich_text_label.get_content_width()
	await get_tree().process_frame
	rich_text_label.size.y = rich_text_label.get_content_height()
	print(rich_text_label.size)
	print(rich_text_label.get_content_height())
	if rich_text_label.size.x > get_viewport_rect().size.x:
		rich_text_label.size.x = get_viewport_rect().size.x - (get_viewport_rect().size.x / 10)
		rich_text_label.size.x = rich_text_label.get_content_width()
		await get_tree().process_frame
		rich_text_label.size.y = rich_text_label.get_content_height()
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "bubble_rect", Rect2(Vector2.ZERO, rich_text_label.size), 0.2)
	tween.tween_method(calculate_bubble_points, bubble_rect, Rect2(Vector2.ZERO, rich_text_label.size), 0.2)
#	calculate_bubble_points()

func final_text_format(txt: String) -> String:
#	# this bit of code will make it so that you the text can easily be made more accessible.
#	# Modify for however you do settings, and more wherever the fonts are.
#	if Settings.override_text_format:
#		#strip out all font change tags from txt
#		var regex = RegEx.new()
#		regex.compile("\\[font.*\\].*\\[\\/font\\]")
#		txt = regex.sub(txt, "", true)
#		if Settings.override_text_font == "OpenDyslexic":
#			txt = "[font=\"res://assets/fonts/OpenDyslexic-Regular.otf\"]" + txt
#		elif Settings.override_text_font == "Hyperlegible":
#			txt = "[font=\"res://assets/fonts/Atkinson-Hyperlegible-Regular-102.otf\"]" + txt
	return txt


func calculate_bubble_data() -> void:
	calculate_bubble_location()


func calculate_bubble_location() -> Vector2:
	return Vector2.ZERO
	pass
	var pos : Vector2 = icutils.get_actor_top_center(speaker)
	if pos_flag == POS_FLAGS.FORCE_BOTTOM or pos.y < icutils.get_cam_center(Vector2(0, -0.166)).y:
		# put the dialogue box in the bottom half of the screen
		pass
	else:
		# put the dialogue box in the top half of the screen
		pass
	return pos


func calculate_bubble_points(rect: Rect2) -> void:
	bubble_points_base = []
	var temp_points : PackedVector2Array = []
	for i in 4:
		prints("index", i)
		temp_points = offset_bubble_points(i, rect)
		bubble_points_base.append_array(temp_points)
	prints("bbpb", bubble_points_base)

func draw_bubble() -> void:
	prints("bubble points", bubble_points)
	draw_colored_polygon(bubble_points, bubble_colour)


func draw_speech_line() -> void:
	pass


func _draw() -> void:
	if bubble_points.is_empty():
		return
	draw_bubble()
	draw_speech_line()

func offset_bubble_points(corner: int, rect: Rect2) -> PackedVector2Array:
	var temp_points : PackedVector2Array = rotate_and_scale_bubble_corner(corner)
	
	match corner:
		0:
			for point in temp_points.size():
				temp_points[point] -= Vector2(bubble_padding, bubble_padding)
		1:
			for point in temp_points.size():
				temp_points[point] += Vector2(bubble_padding + rect.size.x, -bubble_padding)
		2:
			for point in temp_points.size():
				temp_points[point] += Vector2(bubble_padding + rect.size.x, bubble_padding + rect.size.y)
		3:
			for point in temp_points.size():
				temp_points[point] -= Vector2(bubble_padding, -bubble_padding + rect.size.y)
	prints("temp points", temp_points)
	return temp_points


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
	for point in corner.size():
		corner[point] = corner[point] * bubble_corner_size
	prints("corner", turns, corner)
	return corner


func update_bubble_points(delta: float) -> void:
	if bubble_points.is_empty():
		if not bubble_points_base.is_empty():
			bubble_points = bubble_points_base
		else:
			return
	for point in bubble_points_base.size():
		bubble_points[point] = Vector2(
			bubble_points_base[point].x + bubble_point_move_scale * sin(point + delta),
			bubble_points_base[point].y + bubble_point_move_scale * cos(point + delta)
			)


func update_speech_line() -> void:
	pass
