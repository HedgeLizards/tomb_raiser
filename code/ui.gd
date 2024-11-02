extends CanvasLayer

func _on_quit_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().quit()

func _on_quit_mouse_entered():
	$Quit/MarginContainer/HBoxContainer/Label.visible = true

func _on_quit_mouse_exited():
	$Quit/MarginContainer/HBoxContainer/Label.visible = false
