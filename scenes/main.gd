extends Node

@export var game_ui: CanvasLayer
@export var gameover_ui_template: PackedScene

func _ready() -> void:
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	var gameover_ui: GameOverUI = gameover_ui_template.instantiate()
	add_child(gameover_ui)
