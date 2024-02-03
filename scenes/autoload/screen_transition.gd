extends CanvasLayer

signal transition_halfway

var skip_emit = false


func emit_transition_halfway():
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()


func transition():
	transition_in()
 
func transition_in():
	$ColorRect.visible = true
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	transition_halfway.emit()
	transition_out()
 
 
func transition_out():
	$AnimationPlayer.play_backwards("default")
	await $AnimationPlayer.animation_finished
	$ColorRect.visible = false



func transition_to_scene(scene_path : String):
	transition()
	await transition_halfway
	get_tree().change_scene_to_file(scene_path)
