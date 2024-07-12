extends CanvasLayer

@onready var timer_label: Label = %Timer
@onready var gold_label: Label = %Gold
@onready var meat_label: Label = %Meat

func _ready() -> void:
	meat_label.text = str(GameManager.meat_counter)
	

func _process(delta: float) -> void:
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
		
