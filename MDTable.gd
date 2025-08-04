extends Node3D
class_name MDTable

const CARD_PLACER = preload("res://card_placer.tscn")

func _ready() -> void:
	if not is_instance_valid(GameState.current_player_table):
		GameState.current_player_table = self
		
	var index = 0
	for child in get_children():
		if child is Node3D and child.name.begins_with("SLOT_"):
			index += 1
			var instance : CardPlacer = CARD_PLACER.instantiate()
			child.add_child(instance)
			
