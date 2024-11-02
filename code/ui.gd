extends CanvasLayer

const UIAction = preload('res://scenes/ui_action.tscn')

signal end_turn_pressed
signal action_selected(action: AT.ActionType)

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
		%Stats/HBoxContainer/ActionCost/Label.text = 'Action cost: %d' % (selected.stats.walk_cost if selected.stats.walkable else '∞')
		%Stats/HBoxContainer/ActionCost.visible = true
	else:
		%Stats/HBoxContainer/ActionCost.visible = false
	
	if selected.stats.has('health'):
		%Stats/HBoxContainer/Health/Label.text = 'Health: %d/%d' % [selected.stats.health, selected.stats.max_health]
		%Stats/HBoxContainer/Health.visible = true
	else:
		%Stats/HBoxContainer/Health.visible = false
	
	if selected.stats.has('damage'):
		%Stats/HBoxContainer/Damage/Label.text = 'Damage: %d' % selected.stats.damage
		%Stats/HBoxContainer/Damage.visible = true
	else:
		%Stats/HBoxContainer/Damage.visible = false
	
	if selected.stats.has('range'):
		%Stats/HBoxContainer/Range/Label.text = 'Range: %d' % selected.stats.range
		%Stats/HBoxContainer/Range.visible = true
	else:
		%Stats/HBoxContainer/Range.visible = false
	
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

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_packed(load('res://scenes/menu.tscn'))
		elif event.keycode == KEY_M:
			AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))

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

func on_ui_action_selected(action: AT.ActionType):
	action_selected.emit(action)
