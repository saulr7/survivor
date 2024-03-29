extends CanvasLayer

var options_sceen = preload("res://scenes/ui/options_menu.tscn")

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	
	
func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_pressed():
	get_tree().quit()
	
	
func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	var options_instance = options_sceen.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
	
func on_options_closed(options_instance : Node):
	options_instance.queue_free()


func _on_meta_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")
