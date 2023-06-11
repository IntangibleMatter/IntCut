extends Node
class_name IntCutUtils

func get_actor_top_center_screen_position(actor: Node2D) -> Vector2:
	var spr := get_actor_sprite(actor)
	var spr_rect := spr.get_rect()
#	var cam_transform : Transform2D = spr.get_canvas_transform()
	
	var transform_diff = spr.get_global_transform_with_canvas().get_origin()
#		+ spr_rect.position# - Vector2(0, spr_rect.size.y/2)
	
	prints("gatcsp", spr, spr_rect, transform_diff)
	
	return transform_diff

## Translate a world position to a screen position
func world_to_screen(world_coordinates: Vector2) -> Vector2:
	var cam : Vector2 = get_tree().current_scene.get_canvas_transform().origin
	prints("campos", cam)
	return world_coordinates - cam

## get the top center point of an actor
func get_actor_top_center(actor: Node2D) -> Vector2:
	var spr := get_actor_rect(actor)
	prints("spr", spr)
	return spr.position - Vector2(0, spr.size.y/2)

## get an actor's rect
func get_actor_rect(actor: Node2D) -> Rect2:
	var spr := get_actor_sprite(actor)
	if !spr:
		return Rect2()
	var r := spr.get_rect()
	return Rect2(spr.to_global(r.position + r.size/2), r.size)

## get an actor's rect
func get_actor_sprite(actor: Node2D) -> Sprite2D:
	var spr := actor.get_node("Sprite2D") as Sprite2D
	if is_instance_valid(spr):
		return spr
	return null


#func pos_in_cam(world_coordinates: Vector2) -> bool:
#	var cam := get_viewport().get_camera_2d() as Camera2D
#
#	if world_coordinates.x > cam.limit_left and world_coordinates.x < cam.limit_right \
#		and world_coordinates.y > cam.limit_top and world_coordinates.y < cam.limit_bottom:
#			pass
#
#	return false

func get_cam_center(offset: Vector2 = Vector2.ZERO) -> Vector2:
	var cam : Camera2D = get_viewport().get_camera_2d()
	return cam.get_screen_center_position() + (
		offset * (Vector2.ONE / cam.zoom) * get_viewport().get_visible_rect().size
	)


func format_text(text: String) -> String:
	var translated := tr(text)
	translated.replace("\\n", "\n")
	return deal_with_vars(translated)


func deal_with_vars(text: String) -> String:
	var formatted : String
	
	var split_for_vars: PackedStringArray
	for line in text.split("{{"):
		split_for_vars.append_array(line.split("}}"))
	
	if split_for_vars.size() == 1:
		return split_for_vars[0]
	
	for i in range(split_for_vars.size()):
		if i % 2 == 0:
			formatted = formatted + split_for_vars[i]
		else:
			# TODO: replace `Global.get_blackboard_value` with whatever you use to store the game's data that's accessed in cutscenes.
			formatted = formatted #+ str(Global.get_blackboard_value(split_for_vars[i]))
	
	return formatted

