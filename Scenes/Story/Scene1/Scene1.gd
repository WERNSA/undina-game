extends Node2D

func _ready():
	$Islands.scale = Vector2(0.1, 0.1)
	$AnimationPlayer.play("FadeIn")
	show_dialogic()

func _on_Timer_timeout():
	var tween = create_tween()
	tween.tween_property(
		$Islands,
		"scale",
		Vector2(1, 1), 4
	)

func show_dialogic():
	Dialogic.start("intro")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
func _on_dialogic_signal(argument:String):
	if argument == "finished":
		_on_Dialog_timeline_end()

func _on_Dialog_timeline_end():
#	$Islands.position
	var tween = create_tween().set_parallel(true)
	tween.tween_property(
		$Islands,
		"position",
		Vector2(3300, 1100), 2
	)
	tween.tween_property(
		$Islands,
		"scale",
		Vector2(3, 3), 2
	)
	$AnimationPlayer.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene_to_file("res://Scenes/Story/Scene2/Scene2.tscn")
