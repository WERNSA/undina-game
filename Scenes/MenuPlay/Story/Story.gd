extends Control
var actual_checkpoint : String

func _ready() -> void:
	actual_checkpoint = Global.read_story_checkpoint()
	if not actual_checkpoint:
		$ButtonsContainer/SecondContainer/CleanContainer/BtnClean.visible = false


func _on_BtnClean_pressed():
	$SoundPress.play()
	if actual_checkpoint:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Story/"+String(actual_checkpoint)+"/"+String(actual_checkpoint)+".tscn")


func _on_BtnFish_pressed():
	$SoundPress.play()
	Global.write_story_checkpoint("Scene1")
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Story/Scene1/Scene1.tscn")
