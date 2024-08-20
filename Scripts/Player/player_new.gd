extends CharacterBody3D
class_name Player

@export_group("Player Movement")
## Player move speed
@export var moveSpeed: float = 5.0
## Player jump height
@export var jumpHeight: float = 4.5
## Player rotation speed
@export var rotationSpeed: float = 0.1
## Cap of vertical camera movement
@export var verticalLookCap: float = 85.0
## By how much velocity is lerp'd to 0 when there is no movement
@export var inertiaPower: float = 0.15
## Amount by how much to multiply moveSpeed when running
@export var runPower: float = 1.75
## Amount by how much lerp moveSpeed to runSpeed and back
@export var runSmoothing: float = 0.05

var runSpeed: float = moveSpeed * runPower
var defaultSpeed: float = moveSpeed

@onready var debugHud: CanvasLayer = $debugHud

func process_debug_hud() -> void:
	var roundPos: Vector3 = Vector3(snappedf(self.global_position.x, 0.01), snappedf(self.global_position.y, 0.01), snappedf(self.global_position.z, 0.01))
	var roundRot: Vector3 = Vector3(snappedf($Camera3D.global_rotation.x, 0.01), snappedf($Camera3D.global_rotation.y, 0.01), snappedf($Camera3D.global_rotation.z, 0.01))
	var roundVel: Vector3 = Vector3(snappedf(self.velocity.x, 0.01), snappedf(self.velocity.y, 0.01), snappedf(self.velocity.z, 0.01))
	$debugHud/VBoxContainer/playerPosition.text = "Position: {playerPos}".format({"playerPos": roundPos})
	$debugHud/VBoxContainer/playerRotation.text = "Rotation: {playerRot}".format({"playerRot": roundRot})
	$debugHud/VBoxContainer/playerVelocity.text = "Velocity: {playerVel}".format({"playerVel": roundVel})
	$debugHud/VBoxContainer/moveSpeed.text = "moveSpeed: {moveSpeed}".format({"moveSpeed": snappedf(moveSpeed, 0.01)})
	$debugHud/VBoxContainer/currentFPS.text = "FPS: {fps}".format({"fps": snapped(Engine.get_frames_per_second(), 0.01)})

func _process(_delta: float) -> void:
	if OS.is_debug_build():
		process_debug_hud()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jumpHeight

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var new_velocity: Vector3 = Vector3.ZERO
		if Input.is_action_pressed("run"):
			moveSpeed = lerpf(moveSpeed, runSpeed, runSmoothing)
		else:
			moveSpeed = lerpf(moveSpeed, defaultSpeed, runSmoothing)
		new_velocity.x = direction.x * moveSpeed
		new_velocity.z = direction.z * moveSpeed
		
		velocity.x = lerpf(velocity.x, new_velocity.x, inertiaPower)
		velocity.z = lerpf(velocity.z, new_velocity.z, inertiaPower)
		#velocity.x = direction.x * moveSpeed
		#velocity.z = direction.z * moveSpeed
	else:
		# Smoothly getting player to lose velocity when movement isn't present and player is not in air
		if is_on_floor():
			velocity.x = lerpf(velocity.x, 0, inertiaPower)
			velocity.z = lerpf(velocity.z, 0, inertiaPower)
		moveSpeed = lerpf(moveSpeed, defaultSpeed, runSmoothing)
	move_and_slide()

func _input(event: InputEvent) -> void:
	# Handle rotation of the mouse
	if event is InputEventMouseMotion:
		# Rotate camera vertically depending on relative speed of the mouse
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y) * rotationSpeed)
		# Rotate player horizontally depending on relative speed of the mouse
		self.rotate_y(deg_to_rad(-event.relative.x) * rotationSpeed)
		# Clamp camera in vertical projection by verticalLookCap
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, deg_to_rad(-verticalLookCap), deg_to_rad(verticalLookCap))
