extends Node

const SPAWN_RADIUS = 350


@export var base_enemy_scene : PackedScene
@export var wizard_enemy_scene : PackedScene
@export var arena_time_manager : Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	
	enemy_table.add_items(base_enemy_scene, 10)
		
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increase.connect(on_arena_difficulty_increase)


func get_spawn_position():
		
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	
	var random_dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:			
		spawn_position	= player.global_position + (random_dir * SPAWN_RADIUS)
		var additional_offset = random_dir * 20
		
		var queryParams = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(queryParams)
		
		if result.is_empty():
			return spawn_position
		else:
			random_dir = random_dir.rotated(deg_to_rad(90))
	
	return spawn_position
	

func _on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	
	enemy.global_position = get_spawn_position()

func on_arena_difficulty_increase(difficulty: int):
	var time_off = (0.1 / 12) * difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	if difficulty == 6:
		enemy_table.add_items(wizard_enemy_scene, 20)
