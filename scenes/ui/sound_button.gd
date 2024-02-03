extends Button

@onready var stream_player_component = $StreamPlayerComponent


func _on_pressed():
	stream_player_component.play_random()
