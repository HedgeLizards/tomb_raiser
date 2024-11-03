extends Node

func _process(delta):
	if Input.is_action_just_pressed("Debug 1"):
		$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Skeleton")
	if Input.is_action_just_pressed("Debug 2"):
		$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Necromancer")
	if Input.is_action_just_pressed("Debug 3"):
		$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Violin")
	if Input.is_action_just_pressed("Debug 4"):
		$"ADAPTIVE AudioStreamPlayer".get_stream_playback().switch_to_clip_by_name("Celesta")
	if Input.is_action_just_pressed("Debug 5"):
		$"_TEMP SFX".play()
