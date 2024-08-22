extends Node3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var opened: bool = false
var usedTool: Globals.ToolTypes
var opening: bool = true

func interact(toolType: Globals.ToolTypes):
	usedTool = toolType
	if not opened and toolType == Globals.ToolTypes.Wrench:
		anim_player.play("OpenPowerBox")
		opening = true
		await anim_player.animation_finished
		if opening:
			opened = true
	elif toolType != Globals.ToolTypes.Wrench and not opened:
		print("Wrong tool")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("interact") and not opened and usedTool == Globals.ToolTypes.Wrench:
		opening = false
		anim_player.pause()
		anim_player.play_backwards("OpenPowerBox")
		usedTool = Globals.ToolTypes.Hand
