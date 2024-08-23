extends Node

@onready var loadingScene: PackedScene = preload("res://Scenes/menus/loading.tscn")
@onready var optionsMenu: PackedScene = preload("res://Scenes/menus/options.tscn")

var current_state: GameState = GameState.None
var options: Dictionary

@warning_ignore("unused_signal")
signal start_game
@warning_ignore("unused_signal")
signal open_options
@warning_ignore("unused_signal")
signal exit

enum ToolTypes {
	Hand,
	Wrench,
	Screwdriver,
	Taser
}

enum GameState {
	Menu,
	Loading,
	Game,
	Paused,
	None
}
