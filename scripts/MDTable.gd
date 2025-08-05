extends Node3D
class_name MDTable

const CARD_PLACER = preload("res://scenes/prefabs/CardPlacer.tscn")
@onready var pivot_position: Marker3D = $Marker3D

func _ready() -> void:
	GameState.tables.append(self)
	for child in get_children():
		if child is Node3D and child.name.begins_with("SLOT_"):
			var instance : CardPlacer = CARD_PLACER.instantiate()
			child.add_child(instance)

func set_skin(id : int):
	for child in get_children():
		if child.name.begins_with("Skin") and not child.name.ends_with(str(id)):
			child.visible = false
			
