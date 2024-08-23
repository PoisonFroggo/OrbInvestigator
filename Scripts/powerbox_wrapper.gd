extends Node3D

## Object to call "powerbox_used" on
@export var attached_object: Node

func _ready() -> void:
	$Collider.attached_object = attached_object
