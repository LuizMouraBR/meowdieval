extends Node

var cam_drag_speed = 320
var card_anim_speed = 0.35
var is_mobile = OS.get_name() in ["Android", "iOS"]
var current_player_table : Node3D
var cameraRig : Node3D

func aspect_raio():
	var viewport_size = get_viewport().get_visible_rect().size
	return viewport_size.x / viewport_size.y
