extends Node
class_name TableManager
const TABLE = preload("res://scenes/prefabs/table.tscn")
@onready var center: TableManager = $"."
@export var camera_rig : CameraRig

func _ready() -> void:
	update_tables()

func update_tables():
	var fac = (2 * PI) / GameState.player_count
	
	for i in range(GameState.player_count):
		var instance = TABLE.instantiate()
		center.add_child(instance)
		instance.rotate_y(i * fac)
		instance.get_child(0).position.z += GameState.player_count * 0.12
		instance.get_child(0).set_skin(randi_range(1, 4))
	
	camera_rig.change_table(center.get_child(0).get_child(0))
