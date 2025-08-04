extends Node3D
class_name WorldComposer
@onready var reflection_probe: ReflectionProbe = $ReflectionProbe

func _ready() -> void:
	if GameState.is_mobile:
		reflection_probe.queue_free()
