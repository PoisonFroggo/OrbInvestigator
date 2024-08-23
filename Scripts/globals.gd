extends Node

@onready var loadingScene: PackedScene = preload("res://Scenes/menus/loading.tscn")
@onready var optionsMenu: PackedScene = preload("res://Scenes/menus/options.tscn")
@onready var pauseMenu: PackedScene = preload("res://Scenes/menus/pause_menu.tscn")


var options: Dictionary

signal start_game
signal open_options
signal exit

func toggle_mouse_mode() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func _ready():
	if not FileAccess.file_exists("user://settings.json"):
		create_new_settings()
	var settings_file = FileAccess.open("user://settings.json", FileAccess.READ)
	options = JSON.parse_string(settings_file.get_as_text())
	set_options()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		var player = get_tree().get_first_node_in_group("player")
		if player != null:
			print(player.hud)
			for _i in player.get_groups():
				print(_i)
			if player.hud.get_children().size() <= 1:
				player.hud.add_child(pauseMenu.instantiate())
				get_tree().set_pause(true)
				toggle_mouse_mode()

enum ToolTypes {
	Hand,
	Wrench,
	Screwdriver,
	Taser
}

func set_options() -> void:
	set_screenmode(options["fullscreen"])
	write_settings(options)

func set_screenmode(value: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)
	options["fullscreen"] = value

func write_settings(settings: Dictionary) -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	settings_file.store_line(JSON.stringify(settings, "\t"))

func create_new_settings() -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE_READ)
	var settings_template = FileAccess.open("res://Assets/options_template.json", FileAccess.READ).get_as_text()
	settings_file.store_line(JSON.stringify(JSON.parse_string(settings_template), "\t"))
	settings_file.close()
