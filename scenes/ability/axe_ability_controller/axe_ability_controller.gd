extends Node

@export var ability_scene : PackedScene


var base_damage : float = 10
var additional_damage_percent = 1

func _ready():
	GameEvents.ability_upgrades_added.connect(on_ability_upgrades_added)


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		return

	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D	
	if not foreground:
		return
	
	var axe_ability_inst = ability_scene.instantiate() as Node
	foreground.add_child(axe_ability_inst)
	axe_ability_inst.global_position = player.global_position
	
	axe_ability_inst.hit_box_component.damage = base_damage * additional_damage_percent


func on_ability_upgrades_added(upgrade : AbilityUpgrade, current : Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current["axe_damage"]["quantity"] * .10)
		
