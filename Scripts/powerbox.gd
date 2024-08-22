extends Node3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var opened: bool = false
var closing: bool = false

func interact():
	if not opened:
		anim_player.play("OpenPowerBox")
	await anim_player.animation_finished
	if not closing:
		opened = true
	else: 
		closing = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("interact") and not opened:
		anim_player.pause()
		anim_player.play_backwards("OpenPowerBox")
		closing = true
