extends RigidBody3D

func interact(_toolType: Globals.ToolTypes) -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.tablets += 1
	self.queue_free()
