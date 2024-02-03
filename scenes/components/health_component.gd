extends Node

class_name HealthComponent

signal die
signal health_change

@export var max_health : float = 10
var current_health = 0

func _ready():
	current_health =  max_health


func damage(amount:float):
	current_health = max(current_health - amount, 0)
	health_change.emit()
	Callable(check_death).call_deferred()
	
func check_death():
	if current_health == 0:
		die.emit()
		owner.queue_free()

func get_health_percent():
	if max_health <= 0:
		return 0
		
	return min(current_health / max_health,1)
