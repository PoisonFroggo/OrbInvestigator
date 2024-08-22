extends Node
class_name DebugHUD

# Called when the node enters the scene tree for the first time.

var debug_nodes: Array[Node]

func toggle_mouse_mode() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		toggle_mouse_mode()
	if Input.is_action_just_pressed("debug_info"): 
		toggle_debug_info()

func toggle_debug_info() -> void:
	self.visible = !self.visible

func _ready() -> void:
	debug_nodes = get_tree().get_nodes_in_group("debug_info")

func _physics_process(_delta: float) -> void:
	$VBoxContainer/debugLabel.text = ""
	for node in debug_nodes:
		var node_info = node.generate_debug_info() as Dictionary
		$VBoxContainer/debugLabel.text += node_info["debugText"].format(node_info["formatter"])
