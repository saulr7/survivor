extends Node


@export_range(0,1) var drop_percent : float = 0.5

@export var vial_scene : PackedScene
@export var health_component : Node


func _ready():
	(health_component as HealthComponent).die.connect(on_die)


func on_die():
	var adjusted_drop_percent = drop_percent
	
	var xp_count = MetaProgression.get_upgrade_count("experience_game") 
	
	if xp_count > 0:
		adjusted_drop_percent += .1
	
	if randf() > adjusted_drop_percent:
		return		
	
	if vial_scene == null:
		return
	if not owner is Node2D:
		return 
		
	var spawn_pos = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position =  spawn_pos
