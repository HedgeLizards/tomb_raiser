extends ColorRect

func _ready():
	if AudioServer.is_bus_mute(0):
		$Audio.texture = preload('res://textures/UI/UI_SoundOff_250px_trimmed.png')

func toggle_audio():
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
		
		$Audio.texture = preload('res://textures/UI/UI_SoundOn_250px_trimmed.png')
	else:
		AudioServer.set_bus_mute(0, true)
		
		$Audio.texture = preload('res://textures/UI/UI_SoundOff_250px_trimmed.png')

func _input(event):
	if event is InputEventKey and event.keycode == KEY_M and event.pressed and not event.echo:
		toggle_audio()

func _on_play_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_packed(preload('res://scenes/main.tscn'))

func _on_play_mouse_entered():
	%Play.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_play_mouse_exited():
	%Play.get_theme_stylebox('panel').bg_color = Color8(64, 64, 64, 196)

func _on_exit_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().quit()

func _on_exit_mouse_entered():
	%Exit.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_exit_mouse_exited():
	%Exit.get_theme_stylebox('panel').bg_color = Color8(64, 64, 64, 196)

func _on_audio_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_audio()
