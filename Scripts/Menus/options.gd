extends MarginContainer

@onready var main_node := get_parent().get_parent()

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/Backbutton.pressed.connect(func():
		self.queue_free())
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Fullscreen/CheckBox.toggled.connect(SettingsManager.set_screenmode)
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Resolution/OptionButton.item_selected.connect(SettingsManager.set_resolution)
	set_options()

func set_options() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Fullscreen/CheckBox.set_pressed(SettingsManager.options['fullscreen'])
	$PanelContainer/MarginContainer/VBoxContainer/TabContainer/Video/Video/Resolution/OptionButton.select(SettingsManager.options['resolution'])
