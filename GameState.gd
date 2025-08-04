extends Node

var card_anim_speed = 0.35
var is_mobile = OS.get_name() in ["Android", "iOS"]
var current_player_table : Node3D
var md_table: MDTable

func _ready() -> void:
	if is_mobile:
		RenderingServer.viewport_set_scaling_3d_scale(get_viewport(), 0.4)
		get_tree().reload_current_scene()
