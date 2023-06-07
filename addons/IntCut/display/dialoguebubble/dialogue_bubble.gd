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

var corner_points_template : Array[PackedVector2Array] = [
	[ # top left
		Vector2(-1, -0.1),
		Vector2(-0.9, -0.4),
		Vector2(-0.8, -0.6),
		Vector2(-0.6, -0.8),
		Vector2(-0.4, -0.9),
		Vector2(-0.1, -1),
	],
	[ # top right
		Vector2(0.1, -1),
		Vector2(0.4, -0.9),
		Vector2(0.6, -0.8),
		Vector2(0.8, -0.6),
		Vector2(0.9, -0.4),
		Vector2(1, -0.1),
	],
	[ # bottom right
		Vector2(1, 0.1),
		Vector2(0.9, 0.4),
		Vector2(0.8, 0.6),
		Vector2(0.6, 0.8),
		Vector2(0.4, 0.9),
		Vector2(0.1, 1),
	],
	[ # bottom left
		Vector2(-0.1, 1),
		Vector2(-0.4, 0.9),
		Vector2(-0.6, 0.8),
		Vector2(-0.8, 0.6),
		Vector2(-0.9, 0.4),
		Vector2(-1, 0.1),
	],
]
var corner_scale : float = 1

@export var text : PackedStringArray
@export var speaker: Node2D
@export var pos_flag : POS_FLAGS

@export var bubble_oscilate_speed : float = 500
@export var bubble_corner_size := 1
@export var bubble_point_move_scale := 2
@export var bubble_padding := 1

@onready var rich_text_label = $RichTextLabel
@onready var icutils := IntCutUtils.new()

func _ready() -> void:
	bubble_rect = Rect2(calculate_bubble_location(), Vector2(100, 100))
	calculate_bubble_points(bubble_rect)
	rich_text_label.text = """[center][wave amp=30]broooooooooooooo...[/wave] That's [shake level=20]SO COOL[/shake]"""
	waittt()

func _process(delta: float) -> void:
#	prints("template", corner_points_template)
	rich_text_label.position = bubble_rect.position
	update_bubble_points()
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
	var new_rect : Rect2 = Rect2(Vector2(512, 512), rich_text_label.size)
	tween.tween_property(self, "bubble_rect", new_rect, 0.4)
	tween.tween_method(calculate_bubble_points, bubble_rect, new_rect, 0.4)
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
	bubble_points_base = offset_bubble_points(rect)
#	prints("bbpb", bubble_points_base)

func draw_bubble() -> void:
	draw_colored_polygon(bubble_points, bubble_colour)
#	prints("bubble points", bubble_points)


func draw_speech_line() -> void:
	pass


func _draw() -> void:
	if bubble_points.is_empty():
		return
#	prints("bubble points", bubble_points)
	print("drawing!")
	draw_bubble()
	draw_speech_line()

func offset_bubble_points(rect: Rect2) -> PackedVector2Array:
	var temp_points : Array[PackedVector2Array] = []
	
	# separate loop because it infinitely recurses in same loop. Fucked if I know.
	for i in corner_points_template.size():
		temp_points.append(PackedVector2Array())
		for j in corner_points_template[i].size():
			temp_points[i].append(corner_points_template[i][j] * bubble_corner_size)
	
	for i in temp_points.size():
		for point in temp_points[i].size():
			match i:
				0:
					temp_points[i][point] += Vector2(-bubble_padding, -bubble_padding)
#					prints("bipple", i, point, temp_points[i][point])
				1:
					temp_points[i][point] += Vector2(bubble_padding + rect.size.x, -bubble_padding)
#					prints("baaple", i, point, temp_points[i][point])
				2:
					temp_points[i][point] += Vector2(bubble_padding + rect.size.x, bubble_padding + rect.size.y)
#					prints("boople", i, point, temp_points[i][point])
				3:
					temp_points[i][point] += Vector2(-bubble_padding, bubble_padding + rect.size.y)
#					prints("beeple", i, point, temp_points[i][point])

#	prints("temp points", temp_points)
	var tpoints: PackedVector2Array = []
	for i in 4:
		tpoints.append_array(temp_points[i])
		
	return tpoints


func update_bubble_points() -> void:
	bubble_points.clear()
	for point in bubble_points_base.size():
		var newpoint : Vector2
		var pointoffset : Vector2 = Vector2(
			bubble_point_move_scale * sin(point + Time.get_ticks_msec()/bubble_oscilate_speed),
			bubble_point_move_scale * cos(point + Time.get_ticks_msec()/bubble_oscilate_speed)
		)
		var pointsign : Vector2 = bubble_points_base[point].sign()
#		prints("pointttt", bubble_points_base[point], pointsign)
		if pointsign.x < 0:
			newpoint.x = bubble_points_base[point].x - pointoffset.x
		else:
			newpoint.x = bubble_points_base[point].x + pointoffset.x
		if pointsign.y <  0:
			newpoint.y = bubble_points_base[point].y - pointoffset.y
		else:
			newpoint.y = bubble_points_base[point].y + pointoffset.y
		prints("np", newpoint, bubble_rect.position)
		newpoint += bubble_rect.position
		bubble_points.append(newpoint)
		prints("npbbr", newpoint)
#	prints("bubble points", bubble_points)



func update_speech_line() -> void:
	pass
