extends Node


@export var sword_ability: PackedScene
@onready var timer = $Timer

const MAX_RANGE : float = 150
var base_damage = 5
var additional_damage_percent = 1
var base_wait_time = 1.5


func _ready():
	base_wait_time = timer.wait_time
	GameEvents.ability_upgrades_added.connect(on_ability_upgrades_added)


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
		)
	if enemies.size() == 0:
		return
		
	enemies.sort_custom(func(a:Node2D, b : Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	var sword_instance = sword_ability.instantiate() as SwordAbility
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	foreground_layer.add_child(sword_instance)
	sword_instance.hit_box_component.damage = base_damage * additional_damage_percent
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4	
	
	var enemy_dir = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_dir.angle()


func on_ability_upgrades_added(upgrade : AbilityUpgrade, current : Dictionary):
	if upgrade.id == "sword_rate":
		var percent_red = current["sword_rate"]["quantity"] * 0.1
		timer.wait_time = base_wait_time * (1- percent_red)
		timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current["sword_damage"]["quantity"] * .15)
		
