extends Camera3D

@export var toolType: Globals.ToolTypes = Globals.ToolTypes.Hand

@onready var interactRay: RayCast3D = self.get_child(0)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider() as Node
		
		if collider.has_method("interact"):
			collider.call("interact", toolType)
		else:
			push_warning("Collider {collider} has no interact method, skipping interaction".format({"collider": collider}))
