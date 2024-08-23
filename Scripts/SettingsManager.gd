extends Node

var options: Dictionary

func _ready():
	if not FileAccess.file_exists("user://settings.json"):
		create_new_settings()
	var settings_file = FileAccess.open("user://settings.json", FileAccess.READ)
	options = JSON.parse_string(settings_file.get_as_text())
	set_options()

func set_options() -> void:
	set_screenmode(options["fullscreen"])
	set_resolution(options["resolution"])

func set_screenmode(value: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)
	options["fullscreen"] = value
	write_settings(options)

func set_resolution(value: int) -> void:
	var new_resolution: Vector2i
	match value:
		0:
			new_resolution = Vector2(1280, 960)
		1:
			new_resolution = Vector2(1600, 900)
		2:
			new_resolution = Vector2(1920, 1080)
		3:
			new_resolution = Vector2(2560, 1440)
	get_window().content_scale_size = new_resolution
	if new_resolution > get_window().size:
		get_window().content_scale_factor = new_resolution.length() / get_window().size.length()
	elif new_resolution <= get_window().size:
		get_window().content_scale_factor = get_window().size.length() / new_resolution.length()
	options["resolution"] = value
	write_settings(options)

func write_settings(settings: Dictionary) -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	settings_file.store_line(JSON.stringify(settings, "\t"))

func create_new_settings() -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE_READ)
	var settings_template = FileAccess.open("res://Assets/options_template.json", FileAccess.READ).get_as_text()
	settings_file.store_line(JSON.stringify(JSON.parse_string(settings_template), "\t"))
	settings_file.close()
