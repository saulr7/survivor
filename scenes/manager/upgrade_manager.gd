extends Node

#@export var upgrade_pool : Array[AbilityUpgrade]
@export var experience_manager : Node
@export var upgrade_screen_scene : PackedScene

var current_upgrade = {}
var upgrade_pool : WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/swords_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/swords_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")


func _ready():
	upgrade_pool.add_items(upgrade_sword_rate, 10)
	upgrade_pool.add_items(upgrade_sword_damage, 10)
	upgrade_pool.add_items(upgrade_axe, 10)
	upgrade_pool.add_items(upgrade_player_speed, 5)
		
	experience_manager.level_up.connect(on_level_up)


func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = []
	#var filtered_upgrade = upgrade_pool.duplicate()
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade
		chosen_upgrades.append(chosen)
		
	return chosen_upgrades
		

func update_upgrade_pool(chosen : AbilityUpgrade):
	if chosen.id == upgrade_axe.id:
		upgrade_pool.add_items(upgrade_axe_damage, 10)
	

func apply_upgrade(upgrade: AbilityUpgrade):	
	var has_upgrade = current_upgrade.has(upgrade.id)
	if not has_upgrade:
		current_upgrade[upgrade.id] = {
			"resource" : upgrade,
			"quantity" : 1
		}
	else:
		current_upgrade[upgrade.id]["quantity"] += 1
		
	if upgrade.quantity > 0:
		var current = current_upgrade[upgrade.id]["quantity"]
		if current == upgrade.quantity:
			upgrade_pool.remove_item(upgrade)
			#upgrade_pool = upgrade_pool.filter(func (p): return p.id != upgrade.id)
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrade)
	
	
func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(_level : int):	
	var upgrade_screen_ins = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_ins)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_ins.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_ins.upgrade_selected.connect(on_upgrade_selected)
		
	
