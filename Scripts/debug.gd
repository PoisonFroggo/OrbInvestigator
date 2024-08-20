extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func toggle_mouse_mode() -> void:
	Input.mouse_mode = 0 if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else 2

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		toggle_mouse_mode()
	if Input.is_action_just_pressed("debug_info"): 
		toggle_debug_info()

func toggle_debug_info() -> void:
	var player: Player = get_tree().get_first_node_in_group('player')
	player.debugHud.visible = !player.debugHud.visible
