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

var debugHud: Node

var tablets: int = 5

var runSpeed: float = moveSpeed * runPower
var defaultSpeed: float = moveSpeed

@onready var original_col_height: float = $CollisionShape3D.shape.height
@onready var original_height: float = $CSGMesh3D.mesh.height

var crouched: bool = false

var tempDirection: Vector3

var radiation: float = 0.0

var toolset: PackedStringArray = DirAccess.get_files_at("res://Scenes/viewmodels/")
var viewmodels: Array
@onready var viewport: SubViewport = $SubViewportContainer/SubViewport


var current_viewmodel = null
var slots_codes: Array[int] = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]
var inventory: Array[Node] = []


func generate_debug_info() -> Dictionary:
	var roundPos: Vector3 = Vector3(snappedf(self.global_position.x, 0.01), snappedf(self.global_position.y, 0.01), snappedf(self.global_position.z, 0.01))
	var roundRot: Vector3 = Vector3(snappedf($Camera3D.global_rotation_degrees.x, 0.01), snappedf($Camera3D.global_rotation_degrees.y, 0.01), snappedf($Camera3D.global_rotation_degrees.z, 0.01))
	var roundVel: Vector3 = Vector3(snappedf(self.velocity.x, 0.01), snappedf(self.velocity.y, 0.01), snappedf(self.velocity.z, 0.01))
	return {"debugText": "Position: {playerPos}\nRotation: {playerRot}\nVelocity: {playerVel}\nmoveSpeed: {moveSpeed}\nFPS: {fps}\nRad: {radiation}\n",
	"formatter": {"playerPos": roundPos, "playerRot": roundRot, "playerVel": roundVel,
	"moveSpeed": snappedf(moveSpeed, 0.01), "fps": snappedf(Engine.get_frames_per_second(), 0.01), "radiation": radiation}}

func _ready() -> void:
	# Capturing mouse on player ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if OS.is_debug_build():
		debugHud = load("res://Scenes/debugHUD.tscn").instantiate()
		self.add_child(debugHud)
	
	# Adding all viewmodels from folder to array
	if toolset.size() != 0:
		for viewmodel in toolset:
			var current_viewmodel_index = toolset.find(viewmodel)
			toolset[current_viewmodel_index] = "res://Scenes/viewmodels/" + viewmodel
			viewmodels.append(toolset[current_viewmodel_index])
		# Add tools to inventory
		for viewmodel in viewmodels:
			inventory.append(load(viewmodel).instantiate())
		current_viewmodel = inventory[0]
		viewport.add_child(current_viewmodel)

	$TabletCooldown.timeout.connect(func(): $TabletTick.stop())
	$TabletTick.timeout.connect(decayTick)

func decayTick():
	radiation -= 0.03
	radiation = clampf(radiation, 0.0, 1.0)
	if radiation < 0.001:
		$TabletTick.stop()

func _process(_delta: float) -> void:
	
	$TabletsHud/MarginContainer/Amount.text = "Tablets: %s" % tablets
	
	radiation = clampf(radiation, 0.0, 1.0)
	var rad_progress: float = 1.0 - (radiation / 100.0)
	# Setting radiation shaders parameters based on radiation
	# Alpha for shader (disabled for now because in my opinion const alpha looks better
	#$Camera3D/TextureRect.material.set_shader_parameter("radiation", radiation)
	# Amount of random pixels
	$Camera3D/TextureRect.material.set_shader_parameter("progress", rad_progress)
	# Move viewmodel cam to same in-world position as player cam
	if current_viewmodel != null:
		current_viewmodel.global_transform = $Camera3D.global_transform

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var new_velocity := Vector3.ZERO
	if direction:
		tempDirection = direction
		# Handle changing speeds between running and walking
		if Input.is_action_pressed("run") and is_on_floor() and not crouched:
			moveSpeed = lerpf(moveSpeed, runSpeed, runSmoothing)
		else:
			moveSpeed = lerpf(moveSpeed, defaultSpeed, runSmoothing)
		# Smoothly making player move between speed changes
		new_velocity = Vector3(direction.x * moveSpeed, velocity.y, direction.z * moveSpeed)
		velocity = velocity.lerp(new_velocity, inertiaPower)
	else:
		# Smoothly getting player to lose velocity when movement isn't present and player is not in air
		if is_on_floor():
			tempDirection = Vector3.ZERO
			velocity = velocity.lerp(Vector3(0, velocity.y, 0), inertiaPower)
		# If player has no direction set then lerp current moveSpeed towards defaultSpeed
		moveSpeed = lerpf(moveSpeed, defaultSpeed, runSmoothing)
		
		# If direction isn't applied move towards last remembered direction
		new_velocity = Vector3(tempDirection.x * moveSpeed, velocity.y, tempDirection.z * moveSpeed)
		velocity = velocity.lerp(new_velocity, inertiaPower)
	
	if crouched:
		var current_col_height: float = $CollisionShape3D.shape.height
		var current_height: float = $CSGMesh3D.mesh.height
		var new_height = lerpf(current_height, original_height / 2.0, 0.05)
		var new_col_height = lerpf(current_col_height, original_col_height / 2.0, 0.05)
		$Camera3D.transform.origin.y = lerpf($Camera3D.transform.origin.y, 0.25, 0.025)
		
		$CollisionShape3D.shape.height = new_col_height
		$CSGMesh3D.mesh.height = new_height
	elif not crouched:
		var current_col_height: float = $CollisionShape3D.shape.height
		var current_height: float = $CSGMesh3D.mesh.height
		var new_height = lerpf(current_height, original_height, 0.05)
		var new_col_height = lerpf(current_col_height, original_col_height, 0.05)
		$Camera3D.transform.origin.y = lerpf($Camera3D.transform.origin.y, 0.75, 0.025)
		$CollisionShape3D.shape.height = new_col_height
		$CSGMesh3D.mesh.height = new_height
	#
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jumpHeight

	move_and_slide()

func _input(event: InputEvent) -> void:
	# Handle rotation of the mouse
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate camera vertically depending on relative speed of the mouse
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y) * rotationSpeed)
		# Rotate player horizontally depending on relative speed of the mouse
		self.rotate_y(deg_to_rad(-event.relative.x) * rotationSpeed)
		# Clamp camera in vertical projection by verticalLookCap
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, deg_to_rad(-verticalLookCap), deg_to_rad(verticalLookCap))
	
	# Handle slot selection
	if event is InputEventKey and event.is_pressed() and event.keycode in slots_codes:
		var slot = slots_codes.find(event.keycode)
		# Check if viewmodels array has enough slots
		if toolset.size() - 1 >= slot:
			for child in viewport.get_children():
				viewport.remove_child(child)
			current_viewmodel = inventory[slot]
			viewport.add_child(current_viewmodel)
		else:
			print_debug("Tried to select unexisting slot index {slotNum}".format({"slotNum": slot}))
	
	if Input.is_action_just_pressed("tablet") and $TabletCooldown.is_stopped() and tablets and radiation > 0.0:
		tablets -= 1
		$SFX.play()
		$TabletCooldown.start()
		$TabletTick.start()
	
	if Input.is_action_pressed("crouch"):
		crouched = true
	if Input.is_action_just_released("crouch"):
		crouched = false
