extends Node3D
class_name CardBase

@onready var label : Label = $Front/SubViewport/Control/MarginContainer/Panel/MarginContainer/VBoxContainer/Label
@onready var texture_rect : TextureRect = $Front/SubViewport/Control/MarginContainer/Panel/MarginContainer/VBoxContainer/TextureRect
@onready var label_2: Label = $Front/SubViewport/Control/MarginContainer/Panel/MarginContainer/VBoxContainer/Label2
@onready var front_sub_viewport: SubViewport = $Front/SubViewport
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var card_name : String = "CARD_NAME"
@export var texture : Texture2D

var rest_transform : Transform3D
var pile : CardPile

var drawn = 0

func _ready() -> void:
	label.text = card_name
	
	if texture != null:
		texture_rect.texture = texture

## Cancel a card operation, moving it visually back to where it came
func dismiss_card():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_transform", rest_transform, GameState.card_anim_speed)

## Place the card on a CardPlacer (move it hierarchically and visually)
func place(placer : CardPlacer) -> bool:
	if not placer.available:
		return false
	
	# Prevent player from placing card on oponents table!
	if GameState.cameraRig.target_table != placer.md_table:
		return false
	
	top_level = true
	
	# Move node on tree
	if pile != null:
		pile.move_to_placer(placer)
		pile = null
	else:
		var old_placer = get_parent() as CardPlacer
		old_placer.remove_child(self)
		placer.add_child(self)
		old_placer.available = true
	
	rest_transform = placer.global_transform
	placer.available = false
	top_level = false
	dismiss_card()
	
	return true
	
## Return the current card or the topmost card of a pile and move it in front of camera
func select_card() -> CardBase:
	# If the clicked card is part of a pile, the pile will pick the card to be taken
	if pile != null:
		if !pile.card_is_topmost(self):
			return pile.select_topmost()
		
	audio_stream_player.play()
	drawn += 1
	label_2.text = "DRAWN: " + str(drawn)
	front_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	
	rest_transform = global_transform
	var marker = get_viewport().get_camera_3d().get_node("Marker3D")
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(self, "global_position", marker.global_position, GameState.card_anim_speed)
	tween.tween_property(self, "global_rotation", marker.global_rotation, GameState.card_anim_speed)
	return self
