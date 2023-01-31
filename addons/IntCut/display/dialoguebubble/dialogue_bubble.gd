extends Control

var times : float = 0

var scaled := false

@onready var rich_text_label = $RichTextLabel

func _ready():
	rich_text_label.text = "[center][font_size=40]stop. look. listen. boom.[font_size=80] WAITAMINUTE"
	waittt()

func waittt():
	await get_tree().create_timer(4)
	print("GOOO")
	scale_dialogue_box()

func _process(delta):
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
	print(times)
	
