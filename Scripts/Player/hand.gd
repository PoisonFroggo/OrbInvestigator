extends Node3D

var holding: bool = false

@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if !holding:
			animPlayer.play("hold_item")
			holding = true
		else:
			animPlayer.play_backwards("hold_item")
			holding = false
