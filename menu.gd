extends Control
const TABLEPLACE = preload("res://tableplace.tscn")

@onready var label: Label = $GameConfigContainer/VBoxContainer/Label
@onready var h_slider: HSlider = $GameConfigContainer/VBoxContainer/HSlider
@onready var center: Node3D = $center
@onready var cam_pivot: Node3D = $CamPivot
@onready var game_config_container: MarginContainer = $GameConfigContainer
@onready var loading_container: MarginContainer = $LoadingContainer
@onready var progress_bar: ProgressBar = $LoadingContainer/ProgressBar
var target_scene_path = "res://world.tscn"
var load_status = null
var loaded_resource: Resource = null

func _on_h_slider_value_changed(value: float) -> void:
	label.text = str(int(h_slider.value)) + " PLAYERS"
	update_tables()

func _physics_process(delta: float) -> void:
	cam_pivot.rotate_y(delta * 0.04)
	
	if load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var progress = []
		ResourceLoader.load_threaded_get_status(target_scene_path, progress)
		var progress_val = progress[0]
		if progress_val >= 0.0:
			progress_bar.value = progress_val * 100.0
		load_status = ResourceLoader.load_threaded_get_status(target_scene_path)

	elif load_status == ResourceLoader.THREAD_LOAD_LOADED:
		# The scene is fully loaded — now get it and change scene
		loaded_resource = ResourceLoader.load_threaded_get(target_scene_path)
		if loaded_resource:
			get_tree().change_scene_to_packed(loaded_resource)

	elif load_status == ResourceLoader.THREAD_LOAD_FAILED:
		push_error("Failed to load scene: " + target_scene_path)

func _ready() -> void:
	update_tables()

func update_tables():
	for child in center.get_children():
		child.queue_free()
		
	var total = int(h_slider.value)
	var fac = (2 * PI) / total
	
	for i in range(total):
		var instance = TABLEPLACE.instantiate()
		center.add_child(instance)
		instance.rotate_y(i * fac)
		instance.get_child(0).position.z += total * 0.12


func _on_go_button_pressed() -> void:
	game_config_container.visible = false
	loading_container.visible = true
	GameState.player_count = int(h_slider.value)
	ResourceLoader.load_threaded_request(target_scene_path)
	load_status = ResourceLoader.THREAD_LOAD_IN_PROGRESS
