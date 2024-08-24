@tool
extends Marker3D

@export var size: float = 5.0
@export var radiation_potential: float = 0.0025

var body

func _ready() -> void:
	var rad_area := Area3D.new()
	var rad_area_collider := CollisionShape3D.new()
	rad_area_collider.shape = SphereShape3D.new()
	rad_area_collider.shape.radius = size
	self.add_child(rad_area)
	rad_area.add_child(rad_area_collider)
	rad_area.body_entered.connect(rad_area_entered)
	rad_area.body_exited.connect(rad_area_exited)
	$radTicker.timeout.connect(radTick)
	$RayCast3D.target_position.z = -size

func rad_area_entered(enter_body) -> void:
	body = enter_body
	$radTicker.start()

func rad_area_exited(exit_body) -> void:
	body = null
	$radTicker.stop()

func radTick() -> void:
	if "player" in body.get_groups():
		$RayCast3D.look_at(body.global_position)
		if $RayCast3D.is_colliding():
			var collider = $RayCast3D.get_collider()
			if "player" in collider.get_groups():
				body.radiation += radiation_potential
			else:
				body.radiation += radiation_potential / 2.0
