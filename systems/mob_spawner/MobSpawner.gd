class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60.0


@onready var path_follow_2d = %PathFollow2D
var cooldown: float = 0.0	

func _process(delta: float) -> void:
	cooldown -= delta
	
	if cooldown > 0: return
	
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
	
	var point = get_path_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001
	
	var result = world_state.intersect_point(parameters, 1)
	
	if result.is_empty():
		spawn_creature(point)


func get_path_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
	
func get_random_creature() -> Enemy:
	var index = randi_range(0, creatures.size() - 1)
	return creatures[index].instantiate()

func spawn_creature(point: Vector2):
	var creature = get_random_creature()

	creature.global_position = point
	get_parent().add_child(creature)
