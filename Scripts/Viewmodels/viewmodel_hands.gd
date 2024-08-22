extends Camera3D

@export var interactRay: RayCast3D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider()
		print("interacted with {collider}".format({'collider': collider}))
