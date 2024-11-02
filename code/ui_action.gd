extends PanelContainer

const COLOR_DISABLED = Color8(128, 128, 128)

func setUp(action):
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

func _on_mouse_entered():
	get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_mouse_exited():
	get_theme_stylebox('panel').bg_color = Color8(32, 32, 32, 196)
