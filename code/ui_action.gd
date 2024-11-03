extends PanelContainer

signal action_selected(action)

const COLOR_DISABLED = Color8(128, 128, 128)

var action_type
var selected = false

func setUp(action: Selectable.Action):
	$VBoxContainer/Title.text = action.title
	
	for stat in ['action_cost', 'healing', 'damage', 'range']:
		var node = $VBoxContainer/Stats.get_node(stat.to_pascal_case())
		
		if action.stats.has(stat):
			node.get_node('Label').text = str(action.stats[stat])
		else:
			node.queue_free()
	
	if action.enabled:
		mouse_default_cursor_shape = CURSOR_POINTING_HAND
		
		$VBoxContainer/DisabledReason.queue_free()
	else:
		mouse_filter = MOUSE_FILTER_IGNORE
		
		for label in find_children('*', 'Label'):
			label.add_theme_color_override('font_color', COLOR_DISABLED)
		
		$VBoxContainer/DisabledReason.text = '(%s)' % action.disabled_reason
	
	action_type = action.type

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected = not selected
		
		action_selected.emit(action_type if selected else null)
		
		var panel_stylebox = get_theme_stylebox('panel')
		
		panel_stylebox.border_width_left = 4 if selected else 1
		panel_stylebox.border_width_top = 4 if selected else 1
		panel_stylebox.border_width_right = 4 if selected else 1
		panel_stylebox.border_width_bottom = 4 if selected else 1

func _on_mouse_entered():
	get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_mouse_exited():
	get_theme_stylebox('panel').bg_color = Color8(32, 32, 32, 196)
