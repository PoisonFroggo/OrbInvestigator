extends MarginContainer

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/Backbutton.pressed.connect(func():
		self.get_parent().set_process(true)
		self.queue_free())
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Fullscreen/CheckBox.toggled.connect(Globals.set_screenmode)
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Resolution/OptionButton.item_selected.connect(Globals.set_resolution)
	set_options()

func set_options() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Fullscreen/CheckBox.set_pressed(Globals.options['fullscreen'])
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Resolution/OptionButton.select(Globals.options['resolution'])
