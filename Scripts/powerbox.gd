extends Node3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var opened: bool = false


func interact():
	if not opened:
		anim_player.play("OpenPowerBox")
	await anim_player.animation_finished
	opened = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("interact"):
		anim_player.pause()
		anim_player.play_backwards("OpenPowerBox")
