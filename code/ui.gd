extends CanvasLayer

const UIAction = preload('res://scenes/ui_action.tscn')

signal end_turn_pressed
signal action_selected(action: ActionType)

func _ready():
	if OS.has_feature('web'):
		%exit.queue_free()

func _on_cursor_selection_changed(selected):
	if selected == null:
		$Selection.visible = false
		
		return
	
	%Title/Label.text = selected.title
	
	if selected.stats.has('max_action_points'):
		%Stats/HBoxContainer/ActionPoints/Label.text = 'Action points: %d/%d' % [selected.stats.action_points, selected.stats.max_action_points]
		%Stats/HBoxContainer/ActionPoints.visible = true
	else:
		%Stats/HBoxContainer/ActionPoints.visible = false
	
	if selected.stats.has('walk_cost'):
		%Stats/HBoxContainer/ActionCost/Label.text = 'Traversal cost: %s' % (selected.stats.walk_cost if selected.stats.walkable else '∞')
		%Stats/HBoxContainer/ActionCost.visible = true
	else:
		%Stats/HBoxContainer/ActionCost.visible = false
	
	if selected.stats.has('health'):
		%Stats/HBoxContainer/Health/Label.text = 'Health: %d/%d' % [selected.stats.health, selected.stats.max_health]
		%Stats/HBoxContainer/Health.visible = true
	else:
		%Stats/HBoxContainer/Health.visible = false
	
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
			ui_action.action_selected.connect(on_ui_action_selected)
			
			%Actions.add_child(ui_action)
		
		%Actions.visible = true
	
	$Selection.visible = true

func _on_quit_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_packed(load('res://scenes/menu.tscn'))

func _on_quit_mouse_entered():
	$Quit.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)
	$Quit/HBoxContainer/Label.visible = true

func _on_quit_mouse_exited():
	$Quit.get_theme_stylebox('panel').bg_color = Color.TRANSPARENT
	$Quit/HBoxContainer/Label.visible = false

func _on_turn_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		end_turn_pressed.emit()

func _on_turn_mouse_entered():
	$Turn.get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_turn_mouse_exited():
	$Turn.get_theme_stylebox('panel').bg_color = Color8(64, 64, 64, 196)

func on_ui_action_selected(action: ActionType):
	action_selected.emit(action)

func show_notice(notice, seconds = null):
	$Notice.text = notice
	$Notice.modulate.a = 1
	
	if seconds != null:
		$NoticeTimer.start(seconds)
	elif !$NoticeTimer.is_stopped():
		$NoticeTimer.stop()

func hide_notice():
	create_tween().set_trans(Tween.TRANS_SINE).tween_property($Notice, 'modulate:a', 0, 0.2)

func _on_turn_turn_changed(status: int, description: String) -> void:
	show_notice(description, 0.8)
