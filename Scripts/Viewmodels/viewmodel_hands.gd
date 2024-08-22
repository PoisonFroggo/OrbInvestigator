extends Camera3D

@onready var interactRay: RayCast3D = self.get_child(0)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider()
		print("interacted with {collider}".format({'collider': collider}))
