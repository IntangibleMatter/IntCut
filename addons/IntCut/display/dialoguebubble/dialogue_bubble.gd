class_name DialogueBubble
extends Control

enum POS_FLAGS {DEFAULT, FORCE_TOP, FORCE_BOTTOM}

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
	rich_text_label.text = """[center][shake rate=20 level=5][font_size=28]Shut up.[/font_size][/shake]
	[shake rate=30 level=10][font_size=52]Shut up.[/font_size][/shake]
	[shake rate=40 level=2000][font_size=70]SHUT UP![/font_size][/shake]"""
	waittt()

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

	
	var tween := create_tween()
	tween.tween_property(self, "bubble_rect", Rect2(Vector2.ZERO, rich_text_label.size), 0.2)

func final_text_format(txt: String) -> String:
	# this bit of code will make it so that you the text can easily be made more accessible.
	# Modify for however you do settings, and more wherever the fonts are.
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


func calculate_bubble_location() -> Vector2:
	return Vector2(600, 600)
	pass
	var pos : Vector2 = icutils.get_actor_top_center(speaker)
	if pos_flag == POS_FLAGS.FORCE_BOTTOM or pos.y < icutils.get_cam_center(Vector2(0, -0.166)).y:
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
