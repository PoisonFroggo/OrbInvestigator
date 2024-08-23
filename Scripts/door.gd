extends CSGCombiner3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var opened: bool = false

func powerbox_used():
	animation_player.play("door_open")
	await animation_player.animation_finished
	opened = true
