extends CharacterBody2D

#const MAX_SPEED = 40

#@onready var health_component : HealthComponent = $HealthComponent
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent as VelocityComponent
@onready var hurt_box_component = $HurtBoxComponent
@onready var hit_random_player_component = $HitRandomPlayerComponent



func _ready():
	hurt_box_component.hit.connect(on_hit)

func _process(_delta):
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	#var direction = get_direction_to_player()
	#velocity =  direction * MAX_SPEED
	#move_and_slide()
	
	var move_sign = sign(velocity.x)	

	if not move_sign == 0:
		visuals.scale = Vector2(-move_sign,1 )
		
#func get_direction_to_player():
	#var player_node = get_tree().get_first_node_in_group("player") as Node2D
	#if player_node != null:
		#return (player_node.global_position - global_position).normalized()
	#return Vector2.ZERO


func on_hit():
	hit_random_player_component.play_random()
