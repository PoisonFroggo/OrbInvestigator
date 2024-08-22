extends MarginContainer

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/Backbutton.pressed.connect(func():
		self.get_parent().set_process(true)
		self.queue_free())
	$PanelContainer/MarginContainer/VBoxContainer/Fullscreen/CheckBox.toggled.connect(Globals.set_screenmode)
	set_options()

func set_options() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/Fullscreen/CheckBox.set_pressed(Globals.options['fullscreen'])
