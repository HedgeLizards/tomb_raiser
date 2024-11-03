extends Node

func _on_cursor_selection_changed(selected):
	if selected != null:
		match selected.title:
			"Necromancer":
				$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Organ")
			"Undead Army":
				$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Xylophone")
			"Cemetery":
				$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Celesta")
				$"_TEMP SFX".play()
			"Village":
				$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Harp")
			_:
				$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Ensemble")
	else:
		$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Ensemble")
