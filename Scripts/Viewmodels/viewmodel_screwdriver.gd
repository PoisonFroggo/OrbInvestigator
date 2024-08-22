extends Camera3D

@export var interactRay: RayCast3D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider() as Node
		var collider_groups = collider.get_groups()
		
		if "needs_screwdriver" in collider_groups:
			print("interacted with screwdriveable")
		else:
			print("interacted with non screwdriveable")
