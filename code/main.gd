extends Node2D



func _on_ui_end_turn_pressed() -> void:
	%Units.reset_turn()
	%Cursor.select_none()
