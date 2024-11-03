extends Node

enum TurnStatus {PlayerTurn, EnemyTurn}

signal turn_changed(status: TurnStatus, description: String)
signal interact_state_changed(can_interact: bool) # toggle ui buttons

var turn_status: TurnStatus = TurnStatus.PlayerTurn
var is_animating: bool = false

func _on_ui_end_turn_pressed() -> void:
	if !can_interact():
		return
	turn_status = TurnStatus.EnemyTurn
	%Cursor.select_none()
	interact_state_changed.emit(can_interact())
	turn_changed.emit(turn_status, "Enemy turn")
	$Timer.timeout.connect(start_player_turn)
	$Timer.start(1.0)

func start_player_turn() -> void:
	$Timer.timeout.disconnect(start_player_turn)
	turn_status = TurnStatus.PlayerTurn
	%Cursor.select_none()
	%Units.reset_turn()
	turn_changed.emit(turn_status, "Player turn")
	interact_state_changed.emit(can_interact())
	
	


func can_interact() -> bool:
	return turn_status == TurnStatus.PlayerTurn and not is_animating 
