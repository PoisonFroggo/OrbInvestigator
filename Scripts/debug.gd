extends Node
class_name DebugHUD

var debug_nodes: Array[Node]

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_info"):
		toggle_debug_info()

func toggle_debug_info() -> void:
	self.visible = !self.visible

func _ready() -> void:
	debug_nodes = get_tree().get_nodes_in_group("debug_info")

func _physics_process(_delta: float) -> void:
	$VBoxContainer/debugLabel.text = ""
	for node in debug_nodes:
		if node.has_method("generate_debug_info"):
			var node_info = node.generate_debug_info() as Dictionary
			$VBoxContainer/debugLabel.text += "{nodeName}:\n".format({'nodeName': node.name})
			$VBoxContainer/debugLabel.text += node_info["debugText"].format(node_info["formatter"])
		else:
			push_warning("Node {node} marked as debugged doesn't contain info generator, skipping".format({"node": node}))
