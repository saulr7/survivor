extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var random_stream_player_component = $RandomStreamPlayerComponent


func tween_collect(percent: float, start_position : Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if not player:
		return
		
	global_position = start_position.lerp(player.global_position, percent)
	var dir_from_start = player.global_position - start_position
	var target_rotation = dir_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))
	

func collect():	
	GameEvents.emit_exp_vital_collected(1)
	queue_free()

func disabled_collision():
	collision_shape_2d.disabled = true	

func _on_area_2d_area_entered(_area: Area2D):	
	Callable(disabled_collision).call_deferred()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position),0.0, 1.0, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)
	random_stream_player_component.play_random()
