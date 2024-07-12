extends Node

@export var speed: float = 100

var sprite: AnimatedSprite2D
var enemy: Enemy

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
	if GameManager.is_gameover: return
	
	var diff = GameManager.player_position - enemy.position
	var input_vector = diff.normalized()
	enemy.velocity = input_vector * speed
	enemy.move_and_slide()

	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
