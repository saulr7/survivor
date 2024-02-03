extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready():
	GameEvents.player_damage.connect(on_player_damage)


func on_player_damage():
	animation_player.play("hit")
