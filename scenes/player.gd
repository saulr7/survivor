extends CharacterBody2D


@onready var health_component = $HealthComponent
@onready var damage_interval = $DamageInterval
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var random_stream_player_component = $RandomStreamPlayerComponent


var number_coliding_body = 0
var base_speed = 0


func _ready():
	base_speed = velocity_component.max_speed
	health_component.health_change.connect(on_health_change)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrades_added)
	update_health_display()


func _process(_delta):
	var movement_vector = get_movement_vector()
	var dir = movement_vector.normalized()
	velocity_component.accelerate_in_direction(dir)
	velocity_component.move(self)	
	
	if movement_vector.x !=0 or movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
			


func get_movement_vector() -> Vector2:
	
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
	return Vector2(x, y)
	

func check_deal_damage():
	if number_coliding_body <=0 || !damage_interval.is_stopped():
		return
		
	health_component.damage(1)
	damage_interval.start()	
	
	
func update_health_display():
	health_bar.value = health_component.get_health_percent()


func _on_collision_area_2d_body_entered(_body: Node2D):
	number_coliding_body +=1
	check_deal_damage()


func _on_collision_area_2d_body_exited(_body):
	number_coliding_body -=1


func _on_damage_interval_timeout():
	check_deal_damage()
	

func on_health_change():
	update_health_display()
	GameEvents.emit_player_damage()
	random_stream_player_component.play_random()
	
func on_ability_upgrades_added(ability_upgrade: AbilityUpgrade, _current : Dictionary):
	if  ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * _current["player_speed"]["quantity"] * 0.1)
