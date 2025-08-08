extends Node2D

func characters_transition():
	$Characters/IleaSide.visible = false
	$Characters/IleaBack.visible = true
	$Characters/AndresBoy.visible = true

func _ready():
	Dialogic.start("Scene3")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "finished":
		get_tree().change_scene_to_file("res://Scenes/Story/Scene4/Scene4.tscn")
	elif argument == "characters_transition":
		characters_transition()
