extends Node3D
@onready var camera_3d: Camera3D = $Camera3D
@onready var marker_3d: Marker3D = $Camera3D/Marker3D
@onready var selected_object_ui: Control = $SelectedObjectUI
@onready var marker_placer: Marker3D = $Camera3D/MarkerPlacer
@onready var btn_place_card: Button = $SelectedObjectUI/MarginContainer/HBoxContainer/BtnPlaceCard
@export var target_table : Node3D

var hovered_object = null
var selected_object : CardBase = null
var placing_mode = false

func _ready() -> void:
	GameState.cameraRig = self
	rotate_idle()
	update_dof()
	
	if GameState.aspect_raio() < 1.0:
		marker_3d.position.z = -0.55 
		camera_3d.position.z = 4
		camera_3d.fov = 58

func update():
	update_ui()
	update_dof()
	update_object()

func update_object():
	if selected_object == null: return
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var target = marker_3d if not placing_mode else marker_placer
	tween.tween_property(selected_object, "global_transform", target.global_transform, GameState.card_anim_speed)

func update_ui():
	selected_object_ui.visible = selected_object != null
	btn_place_card.visible = not placing_mode

func update_dof():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	var far_dst = 0.01 if selected_object != null and not placing_mode else 10.0
	var amount = 0.14 if selected_object != null and not placing_mode else 0.03
	tween.tween_property(camera_3d.attributes, "dof_blur_far_distance", far_dst, GameState.card_anim_speed)
	tween.tween_property(camera_3d.attributes, "dof_blur_amount", amount, GameState.card_anim_speed)

func rotate_idle():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_rotation", Vector3(deg_to_rad(-38.7), 0, 0), 1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or event is InputEventScreenDrag:
		if selected_object == null:
			self.rotation.y += event.relative.x / -GameState.cam_drag_speed
			self.rotation.x += event.relative.y / -GameState.cam_drag_speed
		elif not placing_mode:
			selected_object.global_rotate(camera_3d.global_transform.basis.y, event.relative.x / GameState.cam_drag_speed)
			selected_object.global_rotate(selected_object.global_transform.basis.x, event.relative.y / GameState.cam_drag_speed)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_check_hover(event.position)
	elif (event is InputEventScreenTouch or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT)) and event.pressed:
		# Update touched object, if any
		if event is InputEventScreenTouch:
			_check_hover(event.position)
		
		# If clicked outside, dismiss
		if selected_object != null && hovered_object != null && hovered_object.get_parent() != selected_object:
			if placing_mode and hovered_object.get_parent() is CardPlacer:
				# If the card WAS able to be placed, continue
				if selected_object.place(hovered_object.get_parent()):
					selected_object = null
					placing_mode = false
			elif not placing_mode:
				selected_object.dismiss_card()
				selected_object = null
			update()
			return
		
		# Hovering a card
		if hovered_object != null && hovered_object.get_parent() is CardBase:
			var card : CardBase = hovered_object.get_parent()

			# If clicked on a card when nothing is selected, select card
			if selected_object == null:
				selected_object = card.select_card()
			
			# If clicked on a different card, select the new one and dismiss the older one
			elif selected_object != card:
				if selected_object.pile != null && selected_object.pile == card.pile:
					selected_object.dismiss_card()
					selected_object = null
				else:
					selected_object.dismiss_card()
					selected_object = card.select_card()
			
			update_dof()
			update_ui()

func _check_hover(mouse_pos):
	var from = camera_3d.project_ray_origin(mouse_pos)
	var to = from + camera_3d.project_ray_normal(mouse_pos) * 100
	
	# DebugDraw3D.draw_line(from, to, Color.RED, 3.0)	

	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		hovered_object = result.collider
	else:
		hovered_object = null


func _on_btn_place_card_pressed() -> void:
	# TODO: Validate if card can be placed!
	
	placing_mode = true
	update()
	

func _on_btn_dismiss_pressed() -> void:
	if placing_mode:
		placing_mode = false
		update()
		return
	
	if selected_object != null and selected_object is CardBase:
		selected_object.dismiss_card()
		selected_object = null
		update()
