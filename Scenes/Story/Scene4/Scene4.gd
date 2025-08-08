extends Node2D

func change_ilea():
	$Background2/IlleaAsustada.visible = false
	$Background2/IlleaMotivada.visible = true

func _ready():
	Dialogic.start("Scene4")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "finished":
		get_tree().change_scene_to_file("res://Scenes/Story/Scene5/Scene5.tscn")
	elif argument == "change_ilea":
		change_ilea()
