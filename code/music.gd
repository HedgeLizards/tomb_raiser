extends Node

func _on_cursor_selection_changed(selected):
	if selected != null:
		match selected.title:
			"Necromancer":
				$Music.get_stream_playback().switch_to_clip_by_name("Organ")
			"Undead Army":
				$Music.get_stream_playback().switch_to_clip_by_name("Xylophone")
			"Human Army":
				$Music.get_stream_playback().switch_to_clip_by_name("CelloViolin")
			"Cemetery":
				$Music.get_stream_playback().switch_to_clip_by_name("Celesta")
				$SFX.play()
			"Village":
				$Music.get_stream_playback().switch_to_clip_by_name("Harp")
			_:
				$Music.get_stream_playback().switch_to_clip_by_name("Ensemble")
	else:
		$Music.get_stream_playback().switch_to_clip_by_name("Ensemble")
