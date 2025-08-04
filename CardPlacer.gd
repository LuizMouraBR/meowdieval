extends Node3D
class_name CardPlacer

@onready var placer_hint: MeshInstance3D = $PlacerHint
var md_table : MDTable
var available : bool = true : 
	set(value):
		available = value
var tween : Tween

func _ready() -> void:
	md_table = get_parent().get_parent()
	
	# If its not *MY* table, placer becomes red
	if md_table != GameState.current_player_table: 
		var mat = placer_hint.get_active_material(0) as StandardMaterial3D
		mat.emission = Color.RED

func _on_area_3d_mouse_entered() -> void:
	if not available: return
	if GameState.cameraRig.selected_object != null and GameState.cameraRig.placing_mode == false: return
	
	if is_instance_valid(tween) and tween.is_running():
		tween.stop()
	
	tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var mat = placer_hint.get_surface_override_material(0)
	tween.tween_property(mat, "albedo_color", Color.WHITE, 0.05)

func _on_area_3d_mouse_exited() -> void:
	if is_instance_valid(tween) and tween.is_running():
		tween.stop()
		
	tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var mat = placer_hint.get_surface_override_material(0)
	tween.tween_property(mat, "albedo_color", Color.TRANSPARENT, 0.5)
