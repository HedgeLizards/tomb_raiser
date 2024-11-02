extends PanelContainer

func setUp(title, stats, disabled_reason):
	$MarginContainer/VBoxContainer/Title.text = title
	
	var stats_label = []
	
	for key in stats:
		stats_label.push_back('%d %s' % [stats[key], key])
	
	$MarginContainer/VBoxContainer/Stats/Label.text = ', '.join(stats_label)
	
	if disabled_reason == null:
		$MarginContainer/VBoxContainer/DisabledReason.visible = false
	else:
		$MarginContainer/VBoxContainer/DisabledReason.text = '(%s)' % disabled_reason
