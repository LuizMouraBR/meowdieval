extends Node

var cam_drag_speed = 320
var card_anim_speed = 0.35
var is_mobile = OS.get_name() in ["Android", "iOS"]
var current_player_table : Node3D
var cameraRig : CameraRig
var tables : Array
var curr_table_index = 0

var banana_value = 24

func aspect_raio():
	var viewport_size = get_viewport().get_visible_rect().size
	return viewport_size.x / viewport_size.y

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_key_label_pressed(KEY_T):
		change_table()
		
func change_table():
	curr_table_index = (curr_table_index + 1) % len(tables)
	var tgt = tables[curr_table_index]
	cameraRig.change_table(tgt)
