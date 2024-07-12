extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_gameover: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_counter: int = 0
var monsters_defeated_counter: int = 0


func _process(delta: float) -> void:
	calculate_elapsed_time(delta)
	
	
func calculate_elapsed_time(delta: float) -> void:
	time_elapsed += delta
	var time_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_in_seconds % 60
	var minutes: int = time_in_seconds / 60
	
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]


func end_game():
	if is_gameover: return
	
	is_gameover = true
	game_over.emit()
	
	
func reset():
	player = null
	player_position = Vector2.ZERO
	is_gameover = false
	
	time_elapsed = 0.0
	time_elapsed_string = "0.0"
	meat_counter = 0
	monsters_defeated_counter = 0
	
	
	for conn in game_over.get_connections():
		game_over.disconnect(conn.callable)
