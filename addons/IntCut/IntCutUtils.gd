extends Node
class_name IntCutUtils

func world_to_screen(world_coordinates: Vector2) -> Vector2:
	var cam := get_viewport().get_camera_2d()
	return world_coordinates - cam.global_position


func get_actor_top_center(actor: Node2D) -> Vector2:
	var spr := actor.get_node("$Sprite2D") as Sprite2D
	return ((spr.texture.get_size() / Vector2(spr.hframes, spr.vframes)) + spr.position)


#func pos_in_cam(world_coordinates: Vector2) -> bool:
#	var cam := get_viewport().get_camera_2d() as Camera2D
#
#	if world_coordinates.x > cam.limit_left and world_coordinates.x < cam.limit_right \
#		and world_coordinates.y > cam.limit_top and world_coordinates.y < cam.limit_bottom:
#			pass
#
#	return false
