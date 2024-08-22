extends MarginContainer

func _ready() -> void:
	$VBoxContainer/StartButton.pressed.connect(func(): Globals.start_game.emit())
	$VBoxContainer/OptionsButton.pressed.connect(func(): Globals.open_options.emit())
	$VBoxContainer/ExitButton.pressed.connect(func(): Globals.exit.emit())
