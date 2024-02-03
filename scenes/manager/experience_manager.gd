extends Node

signal experience_updated(current:float, target_exp:float)
signal level_up(new_level:int)

const TARGET_EXP_GROW = 5

var current_exp = 0
var current_level = 1
var target_exp = 1

func _ready():
	GameEvents.exp_vial_collected.connect(on_exp_vial_collected)

func increment_exp(n:float):
	current_exp = min(current_exp + n, target_exp)
	experience_updated.emit(current_exp, target_exp)
	if current_exp == target_exp:
		current_level +=1
		target_exp += TARGET_EXP_GROW
		current_exp = 0
		experience_updated.emit(current_exp, target_exp)
		level_up.emit(current_level)


func on_exp_vial_collected(number:float):
	increment_exp(number)
