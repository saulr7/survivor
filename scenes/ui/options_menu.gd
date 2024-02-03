extends CanvasLayer


signal back_pressed


@onready var window_button = %WindowButton
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var back = %Back


func _ready():
	update_display()


func update_display():
	window_button.text = "Fullscreen"	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Windowed"
		
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")
		
	
func get_bus_volume_percent(bus_name : String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)
	
	
func set_bus_volume_percent(bus_name : String, percent : float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	
		
func _on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	update_display()		

	
func _on_sfx_slider_value_changed(value):
	set_bus_volume_percent('sfx', value)


func _on_music_slider_value_changed(value):
	set_bus_volume_percent('music', value)


func _on_back_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	back_pressed.emit()
