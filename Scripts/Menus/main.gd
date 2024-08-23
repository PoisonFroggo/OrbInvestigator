extends Node

@onready var menus: Node = $Menus
@onready var game: Node = $Game
@onready var hud: CanvasLayer = $HUD

var path_to_load: String

func _ready() -> void:
	switch_state(Globals.GameState.Menu)

func switch_state(state: Globals.GameState) -> void:
	Globals.current_state = state
	match state:
		Globals.GameState.Loading:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			var loading = Globals.loadingScene.instantiate()
			for child in menus.get_children():
				child.queue_free()
			for child in hud.get_children():
				child.queue_free()
			menus.add_child(loading)
			var level = loading.load_path(path_to_load)
			game.add_child(level.instantiate())
			switch_state(Globals.GameState.Game)
		Globals.GameState.Game:
			for child in menus.get_children():
				child.queue_free()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().set_pause(false)
		Globals.GameState.Menu:
			for child in game.get_children():
				child.queue_free()
			for child in hud.get_children():
				child.queue_free()
			var main_menu = load("res://Scenes/menus/main_menu.tscn").instantiate()
			menus.add_child(main_menu)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Globals.GameState.Paused:
			for child in menus.get_children():
				child.queue_free()
			var pauseMenu = load("res://Scenes/menus/pause_menu.tscn").instantiate()
			hud.add_child(pauseMenu)
			get_tree().set_pause(true)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_:
			pass
			
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape") and Globals.current_state == Globals.GameState.Paused:
		switch_state(Globals.GameState.Game)
	if Input.is_action_just_pressed("escape") and Globals.current_state == Globals.GameState.Game:
		switch_state(Globals.GameState.Paused)
