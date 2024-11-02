extends ColorRect

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_M:
			AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))

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
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
