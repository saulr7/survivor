extends Node2D


@export var health_component : Node
@export var sprite : Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var gpu_particles_2d = $GPUParticles2D
@onready var hit_random_player_component = $HitRandomPlayerComponent



func _ready():
	gpu_particles_2d.texture = sprite.texture
	health_component.die.connect(on_die)


func on_die():
	if not owner:
		return
	var spawn_pos = owner.global_position 
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	
	global_position = spawn_pos
	animation_player.play("default")
	hit_random_player_component.play_random()
	
