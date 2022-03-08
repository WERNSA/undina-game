extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_name:
		$PlayerName.text = Global.player_name


func _on_BtnBack_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Menu/Menu.tscn")


func _on_BtnFish_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Games/Pescando/Pescando.tscn")


func _on_BtnQuiz_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Games/Trivia/Trivia.tscn")
	
