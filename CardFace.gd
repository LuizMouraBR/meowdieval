extends Control
class_name CardFace 

@export var card_name : String = "CARD_NAME"
@export var card_texture : Texture2D

@onready var texture_rect: TextureRect = $MarginContainer/Panel/MarginContainer/VBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/Label

func set_attributes(new_name : String, new_texture : Texture2D):
	card_name = new_name
	card_texture = new_texture
	
	await get_tree().process_frame
	
	label.text = card_name 
	
	if (card_texture != null):
		texture_rect.texture = card_texture
