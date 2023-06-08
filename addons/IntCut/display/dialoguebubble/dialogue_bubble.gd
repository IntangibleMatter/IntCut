class_name DialogueBubble
extends Control

enum POS_FLAGS {DEFAULT, FORCE_TOP, FORCE_BOTTOM}

var scaled := false
## flag to handle weird glitch.
var scaling := false

## stores the position in the dialogue bubble.
var text_position := 0 
## Stores the position in the text string to deal with delays and the like.
var text_string_positon := 0 

## Internal variable used to determine size/position of dialogue bubble.
var bubble_rect: Rect2
## Base of dialogue bubble, used to track points before modification. Constant for each bubble.
var bubble_points_base : PackedVector2Array
## Displayed bubble points.
var bubble_points : PackedVector2Array # Displayed points. Updates.
## Colour of the dialogue bubble.
var bubble_colour := Color.BLACK


## The template used to determine how the corners look.
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

## Array of the text that will be displayed.
@export var text : PackedStringArray
## The actor who is speaking.
@export var speaker: Node2D
## Flag to determine positioning.
@export var pos_flag : POS_FLAGS

## Speed at which bubble oscilates. Higher number is slower.
@export_range(1, 1000) var bubble_oscilate_speed : float = 500
## Factor the corners will be scaled by.
@export var bubble_corner_size := 32
## Factor the corners of the bubble will oscilate by. No set maximum, as
## the number at which the polygon will become invalid (due to self-overlap)
## varies depending on the padding and corner size.
@export var bubble_point_move_scale := 2
## Additional padding between edges of RichTextLabel and the edges of the bubble.
@export var bubble_padding := 1

@onready var rich_text_label = $RichTextLabel
@onready var icutils := IntCutUtils.new()

func _ready() -> void:
	bubble_rect = Rect2(calculate_bubble_location(), Vector2.ZERO)
	calculate_bubble_points(bubble_rect)
	rich_text_label.text =  "[center]" + text[0].replace("\\n", "\n")
	waittt()

func _process(delta: float) -> void:
#	prints("template", corner_points_template)
	if not scaling:
		rich_text_label.size = bubble_rect.size
	rich_text_label.position = bubble_rect.position
	update_bubble_points()
	update_speech_line()
	queue_redraw()


## Debug function. Please ignore.
func waittt() -> void:
	await get_tree().create_timer(4)
	print("GOOO")
	scale_dialogue_box()

## Scales the dialogue box to the new text size.
func scale_dialogue_box() -> void:
	scaling = true
	rich_text_label.size.x = rich_text_label.get_content_width()
	await get_tree().process_frame
	rich_text_label.size.y = rich_text_label.get_content_height()
	prints("init", rich_text_label.size)
	prints("height", rich_text_label.get_content_height())
	if rich_text_label.size.x > get_viewport_rect().size.x:
		rich_text_label.size.x = get_viewport_rect().size.x - (get_viewport_rect().size.x / 10)
		rich_text_label.size.x = rich_text_label.get_content_width()
		await get_tree().process_frame
		rich_text_label.size.y = rich_text_label.get_content_height()
	
	
	await get_tree().process_frame
	var tween := create_tween().set_parallel(true)
	var new_rect : Rect2 = Rect2(calculate_bubble_location(), rich_text_label.size)
	tween.tween_property(self, "bubble_rect", new_rect, 0.4)
	tween.tween_method(calculate_bubble_points, bubble_rect, new_rect, 0.4)
	tween.set_parallel(false)
	tween.tween_property(rich_text_label, "visible_ratio", 1, 1)
	await tween.finished
	# weird glitch where text sometimes changes scale. fixed with this lightly jank permacheck
	scaling = false
	print("post", rich_text_label.size)
	
#	calculate_bubble_points()

## Additional text formatting. Mostly for stuff like accessibility fonts and the like.
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


## Calculates the position of the box and the like
func calculate_bubble_data() -> void:
	calculate_bubble_location()

## Calculate the location of the bubble on the screen.
func calculate_bubble_location() -> Vector2:
	return Vector2(128, 128)
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
#	print("drawing!")
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

## Offsets all the points in the bubble to make it move.
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
#		prints("np", newpoint, bubble_rect.position)
		newpoint += bubble_rect.position
		bubble_points.append(newpoint)
#		prints("npbbr", newpoint)
#	prints("bubble points", bubble_points)


## Changes to the next line of dialogue
func update_speech_line() -> void:
	pass
