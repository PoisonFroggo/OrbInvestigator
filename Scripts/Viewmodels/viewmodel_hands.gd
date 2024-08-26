extends Camera3D

@export var toolType: Globals.ToolTypes = Globals.ToolTypes.Hand

@onready var interactRay: RayCast3D = self.get_child(0)

var picked_up_item: Node3D = null

func _exit_tree() -> void:
	if picked_up_item:
		interactRay.remove_exception(picked_up_item)
		picked_up_item.gravity_scale = 1.0
		picked_up_item.linear_velocity /= 2.0
	picked_up_item = null

func _physics_process(_delta: float) -> void:
	if picked_up_item != null:
		picked_up_item.gravity_scale = 0
		picked_up_item.linear_velocity = Vector3.ZERO
		var new_target = interactRay.target_position
		new_target = new_target.rotated(Vector3(1, 0, 0), interactRay.global_rotation.x)
		new_target = new_target.rotated(Vector3(0, 1, 0), interactRay.global_rotation.y)
		new_target = new_target.rotated(Vector3(0, 0, 1), interactRay.global_rotation.z)
		picked_up_item.linear_velocity = ((interactRay.global_transform.origin + new_target) - picked_up_item.global_position) * 10.0
		picked_up_item.global_rotation = interactRay.global_rotation

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and picked_up_item:
			interactRay.remove_exception(picked_up_item)
			picked_up_item.gravity_scale = 1.0
			picked_up_item.linear_velocity /= 2.0
			picked_up_item = null
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider() as Node
		if "pickable" in collider.get_groups() and not picked_up_item:
			picked_up_item = collider
			interactRay.add_exception(collider)
			return
		if collider.has_method("interact"):
			collider.call("interact", toolType)
		else:
			push_warning("Collider {collider} has no interact method, skipping interaction".format({"collider": collider}))
