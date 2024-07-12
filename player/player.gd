class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0,0)
@export_category("Movement")
@export var speed: float = 300
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 5
@export var ritual_interval: float = 10
@export var ritual_scene: PackedScene
@export_category("Health")
@export var health: int = 50
@export var max_health: int = 100
@export var death_prefab: PackedScene

var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0

signal meat_collected(value: int)

func _ready() -> void:
	GameManager.player = self
	meat_collected.connect(func(value: int): GameManager.meat_counter += 1)
	

func _process(delta: float) -> void:
	GameManager.player_position = position
	read_input()
	
	update_attack_coldown(delta)	
	update_hitbox_detection(delta)
	update_ritual(delta)
	update_health_bar()
			 
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
		rotate_sprite()

		
	if Input.is_action_just_pressed("attack"):
		attack()

		

func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * speed
	if is_attacking:
		target_velocity *= 0.25
		
	velocity = lerp(velocity, target_velocity, 0.2)
	move_and_slide()
	

func read_input() -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	

func update_attack_coldown(delta: float):
	if is_attacking:
		attack_cooldown -= delta	
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")


func update_ritual(delta: float):
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)
	
func update_health_bar():
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
	
	
func rotate_sprite() -> void:
	if input_vector.x > 0:
		sprite2d.flip_h = false 
	elif input_vector.x < 0:
		sprite2d.flip_h = true
		
	
func attack() -> void:
	if is_attacking:
		return
	
	# attack_side_1
	# attack_side_2
	animation_player.play("attack_side_1")
	is_attacking = true
	attack_cooldown = 0.6
	

func deal_damage() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite2d.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
				
			var dot_product = direction_to_enemy.dot(attack_direction)
			
			if dot_product >= 0.3:
				enemy.damage(sword_damage)

			
func damage(amount: int) -> void:
	if health <= 0:
		return
		
	health -= amount
	print("Player: ", amount, " Damage received. Total health: ", health)
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	if health <= 0:
		die()
		

func die() -> void:
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()

func update_hitbox_detection(delta: float):
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 2
			damage(damage_amount)
			
			

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
		
	print(amount, " heal received. Total life: ", health)
	return health
