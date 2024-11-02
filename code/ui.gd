extends CanvasLayer

const UIAction = preload('res://scenes/ui_action.tscn')

func _ready():
	%Title/MarginContainer/HBoxContainer/Label.text = 'Necromancer'
	%Stats/MarginContainer/HBoxContainer/Label.text = 'Action points: 5/10'
	
	add_action('Heal Undead', {
		'action points': 2,
		'range': 3,
	}, null)
	add_action('Raise Undead', {
		'action points': 3,
		'range': 2,
	}, 'no bones in range')
	
	$Selection.visible = true

func add_action(title, stats, disabled_reason):
	var ui_action = UIAction.instantiate()
	
	ui_action.setUp(title, stats, disabled_reason)
	
	%Actions.add_child(ui_action)

func _on_quit_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().quit()

func _on_quit_mouse_entered():
	$Quit/MarginContainer/HBoxContainer/Label.visible = true

func _on_quit_mouse_exited():
	$Quit/MarginContainer/HBoxContainer/Label.visible = false
