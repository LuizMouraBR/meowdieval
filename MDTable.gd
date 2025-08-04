extends Node3D
class_name MDTable

const CARD_PLACER = preload("res://card_placer.tscn")
@onready var pivot_position: Marker3D = $Marker3D

func _ready() -> void:
	GameState.tables.append(self)
	
	var index = 0
	for child in get_children():
		if child is Node3D and child.name.begins_with("SLOT_"):
			index += 1
			var instance : CardPlacer = CARD_PLACER.instantiate()
			child.add_child(instance)
			
