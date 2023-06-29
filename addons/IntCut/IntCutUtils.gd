extends Node
class_name IntCutUtils

func get_actor_closest_dialogue_screen_position(actor: Node2D, point: Vector2) -> Vector2:
	var potential_points : PackedVector2Array
	
	var points_of_box := get_actor_screen_box_points(actor)
	
	#prints("bp", points_of_box)
	
	for i in points_of_box.size():
		potential_points.append(Geometry2D.get_closest_point_to_segment(point, points_of_box[i - 1], points_of_box[i]))
	
	var final_point : Vector2
	var closest_distance : float = INF
	
	for p in potential_points:
		var dsquared := point.distance_squared_to(p)
		if dsquared < closest_distance:
			closest_distance = dsquared
			final_point = p
	
	return final_point


func get_actor_screen_bounding_rect(actor: Node2D) -> Rect2:
	var actor_box_points := get_actor_screen_box_points(actor)
#	prints("unsorted", actor_box_points)
	actor_box_points.sort()
#	prints("sorted", actor_box_points)
	var bounding := Rect2()
	var left := actor_box_points[0].x
	var right := actor_box_points[-1].x
	var top : float = 999999
	var bottom : float = -999999
	
	for point in actor_box_points:
		if point.y < top:
			top = point.y
		if point.y > bottom:
			bottom = point.y
	
	bounding.position = Vector2(left, top)
	bounding.size = Vector2(right, bottom) - bounding.position
	
#	prints("bounding", bounding, top, left, bottom, right)
	return bounding


func get_actor_screen_box_points(actor: Node2D) -> PackedVector2Array:
	var spr := get_actor_sprite(actor)
	var spr_rect := spr.get_rect()
	var spr_transform := spr.get_global_transform_with_canvas()
	var points_of_box : PackedVector2Array = [
		(spr_transform.get_origin() + spr_rect.position.rotated(spr_transform.get_rotation()) * spr_transform.get_scale()),
		(spr_transform.get_origin() + (spr_rect.position + Vector2(spr_rect.size.x, 0)).rotated(spr_transform.get_rotation()) * spr_transform.get_scale()),
		(spr_transform.get_origin() + (spr_rect.position + spr_rect.size).rotated(spr_transform.get_rotation()) * spr_transform.get_scale()),
		(spr_transform.get_origin() + (spr_rect.position + Vector2(0, spr_rect.size.y)).rotated(spr_transform.get_rotation()) * spr_transform.get_scale()),
	]
	return points_of_box


func is_rect_on_screen(rect: Rect2) -> bool:
	var cam : Rect2 = get_viewport().get_visible_rect()
	prints("rect", cam)
	return rect.intersects(cam)


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

## get an actor's sprite
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

