extends Node3D
class_name CardPlacer

@onready var placer_hint: MeshInstance3D = $PlacerHint
var md_table : MDTable
var available : bool = true : 
	set(value):
		var mat = placer_hint.get_surface_override_material(0)
		mat.emission = Color.GREEN if value else Color.RED
		available = value
		

func _ready() -> void:
	md_table = get_parent().get_parent()

func _on_area_3d_mouse_entered() -> void:
	if not available: return
	if md_table != GameState.current_player_table: return
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var mat = placer_hint.get_surface_override_material(0)
	tween.tween_property(mat, "albedo_color", Color.WHITE, 0.05)

func _on_area_3d_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var mat = placer_hint.get_surface_override_material(0)
	tween.tween_property(mat, "albedo_color", Color.TRANSPARENT, 0.5)
