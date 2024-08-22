extends Camera3D

@onready var interactRay: RayCast3D = self.get_child(0)
@onready var charge_label: Label = $HUD/MarginContainer/Charge
@onready var shooting_ray: RayCast3D = $shootingRay

@export_group("Shooting parameters")
## How much of charge percentage take per shot
@export_range(0, 10, 1, "or_greater", "suffix:%") var charge_per_shot: int = 10
## Maximum amount of charge
@export_range(0, 100) var max_charge: int = 100
var charge: int = max_charge
var charging: bool = false



func _ready() -> void:
	$chargeTick.timeout.connect(chargeTick)

func _process(_delta: float) -> void:
	charge_label.text = "{charge}%".format({"charge": charge})

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and interactRay.is_colliding():
		var collider = interactRay.get_collider() as Node
		var collider_groups = collider.get_groups()
		
		if "can_charge" in collider_groups:
			charging = true
			get_tree().create_timer(max_charge / charge_per_shot).timeout.connect(stopCharge)
			$chargeTick.start(1)
		else:
			print("interacted with unchargeable")

	if Input.is_action_just_pressed("primary_fire"):
		if charge >= charge_per_shot and not charging:
			charge -= charge_per_shot
			if shooting_ray.is_colliding():
				var collider = shooting_ray.get_collider()
				if collider.has_method("tasered"):
					collider.call("tasered")
				else:
					print("hit untaserable")
		else:
			print("no charge")

func chargeTick() -> void:
	if charge <= max_charge:
		charge += charge_per_shot
		charge = clampi(charge, 0, max_charge)
	else:
		stopCharge()

func stopCharge() -> void:
	$chargeTick.stop()
	charging = false
