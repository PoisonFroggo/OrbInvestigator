extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_object(90)

func rotate_object(degrees: float):
	var radians = deg_to_rad(degrees)
	rotate_y(radians)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
