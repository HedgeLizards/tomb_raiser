extends PanelContainer

const COLOR_DISABLED = Color8(128, 128, 128)

var enabled

func setUp(title, stats, disabled_reason):
	$VBoxContainer/Title.text = title
	
	var stats_label = []
	
	for key in stats:
		stats_label.push_back('%d %s' % [stats[key], key])
	
	$VBoxContainer/Stats/Label.text = ', '.join(stats_label)
	
	enabled = disabled_reason.is_empty()
	
	if not enabled:
		mouse_default_cursor_shape = CURSOR_ARROW
		
		$VBoxContainer/Title.add_theme_color_override('font_color', COLOR_DISABLED)
		$VBoxContainer/Stats/Label.add_theme_color_override('font_color', COLOR_DISABLED)
		$VBoxContainer/DisabledReason.add_theme_color_override('font_color', COLOR_DISABLED)
		
		$VBoxContainer/DisabledReason.text = '(%s)' % disabled_reason
		$VBoxContainer/DisabledReason.visible = true

func _on_mouse_entered():
	if enabled:
		get_theme_stylebox('panel').bg_color = Color8(96, 96, 96)

func _on_mouse_exited():
	if enabled:
		get_theme_stylebox('panel').bg_color = Color8(32, 32, 32, 196)
