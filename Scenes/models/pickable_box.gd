extends RigidBody3D


func generate_debug_info() -> Dictionary:
	var roundVel = snapped(linear_velocity, Vector3(0.01, 0.01, 0.01))
	return {"debugText": "Velocity: {velocity}",
	"formatter": {"velocity": roundVel}}
