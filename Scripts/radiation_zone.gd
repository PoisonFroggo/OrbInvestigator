@tool
extends Marker3D

@export var size: float = 5.0
@export var radiation_potential: float = 0.0025
@export var tick_intervals: float = 1.0

var body

func _ready() -> void:
	var rad_area := $Area3D
	var rad_area_collider := $Area3D/CollisionShape3D
	rad_area_collider.shape.radius = size
	rad_area.body_entered.connect(rad_area_entered)
	rad_area.body_exited.connect(rad_area_exited)
	$radTicker.timeout.connect(radTick)
	$RayCast3D.target_position.z = -size

func _process(_delta: float) -> void:
	if body != null:
		$RayCast3D.look_at(body.global_position)

func rad_area_entered(enter_body) -> void:
	body = enter_body
	$radTicker.start(tick_intervals)

func rad_area_exited(_exit_body) -> void:
	body = null
	$radTicker.stop()

func radTick() -> void:
	var applied_rad: float = radiation_potential
	if "player" in body.get_groups():
		if $RayCast3D.is_colliding():
			var collider = $RayCast3D.get_collider()
			if "player" in collider.get_groups():
				applied_rad = radiation_potential
			else:
				applied_rad = radiation_potential / 2.0
		body.radiation += applied_rad
