class_name GameOverUI
extends CanvasLayer

@onready var time_value: Label =  %TimeValue
@onready var monsters_value: Label = %MonstersValue

@export var restart_delay: float = 5.0
var restart_cooldown: float
var time_survived: String

func _ready() -> void:
	restart_cooldown = restart_delay
	time_value.text = GameManager.time_elapsed_string
	monsters_value.text = str(GameManager.monsters_defeated_counter)
	

func _process(delta: float) -> void: 
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
	
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()

