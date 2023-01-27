extends Node
class_name IntCutUtils

func world_to_screen(world_coordinates: Vector2) -> Vector2:
	var cam := get_viewport().get_camera_2d()
	return world_coordinates - cam.global_position


func pos_in_cam(world_coordinates: Vector2) -> bool:
	var cam := get_viewport().get_camera_2d()
	
	return false
