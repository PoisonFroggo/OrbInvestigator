extends VBoxContainer

func set_progress(value: float) -> void:
	$ProgressBar.value = value

func load_path(filepath: String) -> Resource:
	ResourceLoader.load_threaded_request(filepath, "PackedScene", true)
	var progress: Array[float] = []
	var prev_progress: float = -1
	while ResourceLoader.load_threaded_get_status(filepath, progress) != ResourceLoader.THREAD_LOAD_LOADED:
		if prev_progress != progress[0]:
			prev_progress = progress[0]
			set_progress(progress[0])
	var Level: Resource = ResourceLoader.load_threaded_get(filepath)
	return Level