extends Node

signal arena_difficulty_increase(arena_difficulty : int)

const DIFFICULTY_INTERVAL = 5

@export var end_screne_scene : PackedScene

@onready var timer = $Timer
var arena_difficulty = 0



func _process(_delta):
	var next_time_targer = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_targer:
		arena_difficulty +=1
		arena_difficulty_increase.emit(arena_difficulty)
		

func get_time_elapse():
	return timer.wait_time - timer.time_left


func _on_timer_timeout():
	var end_instance = end_screne_scene.instantiate()
	add_child(end_instance)
	end_instance.play_jingle()
	MetaProgression.save()
