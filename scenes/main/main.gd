extends Node

@export var end_screen_scene : PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")

@onready var player = %Player

func _ready():
	player.health_component.die.connect(on_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
	

func on_died():
	var end_screne_ins = end_screen_scene.instantiate()
	add_child(end_screne_ins)
	end_screne_ins.set_defeat()
	MetaProgression.save()
	
