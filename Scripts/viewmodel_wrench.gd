extends Camera3D

@onready var interactRay: RayCast3D = self.get_child(0)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider() as Node
		var collider_groups = collider.get_groups()
		
		if "needs_wrench" in collider_groups:
			if collider.has_method("interact"):
				collider.call("interact")
				print("interacted with wrenchable")
			else:
				push_warning("Collider {collider} has no interact method, skipping interaction".format({"collider": collider}))
		else:
			print("interacted with non wrenchable")
