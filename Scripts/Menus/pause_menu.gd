extends MarginContainer

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/GameButton.pressed.connect(func():
		get_tree().set_pause(false)
		self.queue_free()
		Globals.toggle_mouse_mode())
	$PanelContainer/MarginContainer/VBoxContainer/Options.pressed.connect(open_options)
	$PanelContainer/MarginContainer/VBoxContainer/MainMenuButton.pressed.connect(go_to_main_menu)

func open_options() -> void:
	var options_menu = Globals.optionsMenu.instantiate()
	self.add_child(options_menu)
	self.get_parent().set_process(false)

func go_to_main_menu() -> void:
	var level = get_tree().get_first_node_in_group("player").get_parent()
	var root = level.get_parent()
	var menu = load("res://Scenes/menus/main_menu.tscn")
	root.get_child(0).add_child(menu.instantiate())
	get_tree().set_pause(true)
	level.queue_free()
