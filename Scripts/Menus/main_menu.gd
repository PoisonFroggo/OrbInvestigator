extends Control

@onready var main_menu := preload("res://Scenes/menus/main.tscn")

@export_file("*.tscn") var FirstLevelPath: String = "res://Scenes/levels/level_1_test.tscn"

func _ready() -> void:
	self.add_child(main_menu.instantiate())
	Globals.open_options.connect(open_options)
	Globals.exit.connect(exit_game)
	Globals.start_game.connect(start_game)

func start_game() -> void:
	var parent_node = self.get_parent()
	self.hide()
	var loading_scene = Globals.loadingScene.instantiate()
	parent_node.add_child(loading_scene)
	ResourceLoader.load_threaded_request(FirstLevelPath, "PackedScene", true, ResourceLoader.CACHE_MODE_REPLACE)
	var progress: Array[float] = []
	var prev_progress: float = -1
	while ResourceLoader.load_threaded_get_status(FirstLevelPath, progress) != ResourceLoader.THREAD_LOAD_LOADED:
		if prev_progress != progress[0]:
			prev_progress = progress[0]
			loading_scene.set_progress(progress[0])
	var FirstLevel: Node = ResourceLoader.load_threaded_get(FirstLevelPath).instantiate()
	parent_node.get_parent().add_child(FirstLevel)
	loading_scene.queue_free()
	self.queue_free()

func open_options() -> void:
	var options_menu = Globals.optionsMenu.instantiate()
	self.add_child(options_menu)
	self.set_process(false)

func exit_game() -> void:
	get_tree().quit()
