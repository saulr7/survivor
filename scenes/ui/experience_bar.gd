extends CanvasLayer


@export var experience_manager : Node
@onready var progress_bar = $MarginContainer/ProgressBar


func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_exp_updated)


func on_exp_updated(current: float, target: float):
	var percent = current / target
	progress_bar.value = percent
