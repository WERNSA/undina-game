extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_name:
		$PlayerName.text = Global.player_name


func _on_BtnBack_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/MenuPlay/MenuPlay.tscn")


func _on_BtnFish_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Games/Pescando/Nivel1/Pescando.tscn")


func _on_BtnClean_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Games/Pescando/Nivel2/Pescando.tscn")


func _on_BtnLvl3_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Games/Pescando/Nivel3/Pescando.tscn")
	
