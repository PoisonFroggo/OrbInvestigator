extends MarginContainer

@onready var main_node := get_parent().get_parent()

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/GameButton.pressed.connect(func():
		main_node.switch_state(Globals.GameState.Game)
		self.queue_free())
	$PanelContainer/MarginContainer/VBoxContainer/Options.pressed.connect(open_options)
	$PanelContainer/MarginContainer/VBoxContainer/MainMenuButton.pressed.connect(go_to_main_menu)

func open_options() -> void:
	var options_menu = Globals.optionsMenu.instantiate()
	get_parent().add_child(options_menu)

func go_to_main_menu() -> void:
	main_node.switch_state(Globals.GameState.Menu)
