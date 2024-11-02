extends PanelContainer

const COLOR_DISABLED = Color8(128, 128, 128)

var disabled

func setUp(action):
	$VBoxContainer/Title.text = action.title
	
	var stats_label = []
	
	for key in action.stats:
		stats_label.push_back('%d %s' % [action.stats[key], key])
	
	$VBoxContainer/Stats/Label.text = ', '.join(stats_label)
	
	if action.enabled:
		return
	
	mouse_filter = MOUSE_FILTER_IGNORE
	mouse_default_cursor_shape = CURSOR_ARROW
	
	$VBoxContainer/Title.add_theme_color_override('font_color', COLOR_DISABLED)
	$VBoxContainer/Stats/Label.add_theme_color_override('font_color', COLOR_DISABLED)
	$VBoxContainer/DisabledReason.add_theme_color_override('font_color', COLOR_DISABLED)
	
	$VBoxContainer/DisabledReason.text = '(%s)' % action.disabled_reason
	$VBoxContainer/DisabledReason.visible = true

func _on_mouse_entered():
	get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_mouse_exited():
	get_theme_stylebox('panel').bg_color = Color8(32, 32, 32, 196)
