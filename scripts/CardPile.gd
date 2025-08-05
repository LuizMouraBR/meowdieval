extends Node3D
class_name CardPile
const CARD_SCENE = preload("res://scenes/prefabs/CardBase.tscn")

func _ready() -> void:
	for i in range(10):
		var instance : CardBase = CARD_SCENE.instantiate()
		instance.card_name = "CARDPILE " + str(i)
		instance.pile = self
		self.add_child(instance)
		instance.position.y += i * 0.002
		instance.rotation.z = deg_to_rad(180)
		instance.rotation.y = randf_range(-0.2, 0.2)

func move_to_placer(placer : CardPlacer):
	var card = select_topmost()
	remove_child(card)
	placer.add_child(card)

func select_topmost() -> CardBase:
	var card = (self.get_children()[-1] as CardBase)
	card.select_card()
	return card

func card_is_topmost(card : CardBase):
	return card == (self.get_children()[-1] as CardBase)
