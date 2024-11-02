extends ColorRect

func _on_play_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_packed(preload('res://scenes/main.tscn'))

func _on_play_mouse_entered():
	%Play.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_play_mouse_exited():
	%Play.get_theme_stylebox('panel').bg_color = Color8(64, 64, 64, 196)
