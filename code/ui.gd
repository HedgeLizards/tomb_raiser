extends CanvasLayer

const UIAction = preload('res://scenes/ui_action.tscn')

signal end_turn_pressed

func _on_cursor_selection_changed(selected):
	if selected == null:
		$Selection.visible = false
		
		return
	
	%Title/HBoxContainer/Label.text = selected.title # selected.stats.health
	#%Stats/HBoxContainer/Label.text = 'Action points: %d' % selected.stats.action_points
	
	if selected.actions.is_empty():
		%Description.text = selected.description
		%Description.visible = true
		%Actions.visible = false
	else:
		%Description.visible = false
		
		for action in %Actions.get_children():
			action.queue_free()
		
		for action in selected.actions:
			var ui_action = UIAction.instantiate()
			
			ui_action.setUp(action)
			
			%Actions.add_child(ui_action)
		
		%Actions.visible = true
	
	$Selection.visible = true

func _on_quit_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().quit()

func _on_quit_mouse_entered():
	$Quit.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)
	$Quit/HBoxContainer/Label.visible = true

func _on_quit_mouse_exited():
	$Quit.get_theme_stylebox('panel').bg_color = Color.TRANSPARENT
	$Quit/HBoxContainer/Label.visible = false

func _on_turn_mouse_entered():
	$Turn.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_turn_mouse_exited():
	$Turn.get_theme_stylebox('panel').bg_color = Color8(64, 64, 64, 196)


func _on_turn_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		end_turn_pressed.emit()
