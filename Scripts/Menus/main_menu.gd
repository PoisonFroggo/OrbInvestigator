extends Control

@onready var main_menu := preload("res://Scenes/menus/main.tscn")
@onready var main_node := get_parent().get_parent()

@export_file("*.tscn") var LevelPath: String = "res://Scenes/levels/level_1_test.tscn"

func _ready() -> void:
	self.add_child(main_menu.instantiate())
	Globals.start_game.connect(start_game)
	Globals.open_options.connect(open_options)
	Globals.exit.connect(exit_game)

func start_game() -> void:
	main_node.path_to_load = LevelPath
	main_node.switch_state(Globals.GameState.Loading)

func open_options() -> void:
	var options_menu = Globals.optionsMenu.instantiate()
	self.add_child(options_menu)
	self.set_process(false)

func exit_game() -> void:
	get_tree().quit()
