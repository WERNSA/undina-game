extends Node2D

onready var TRASH_COUNT = 0
var trash_array
onready var actual_trash = null
onready var position_offset = 60
onready var position_out_screen = 1900 + position_offset
onready var trash_transition_time = 15
onready var game_over = false
onready var tries = 3
var trash_qty

func _ready():
	randomize()
	$Background/Contador.set_count(str(TRASH_COUNT))
	trash_array = get_tree().get_nodes_in_group('enemy')
	trash_qty = len(trash_array)
	$Crab/SpawnTimer.start()
	$Tries/MarginContainer/LblTries.text = "INTENTOS: " + str(tries)
	$HUD/GameOver/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$HUD/Win/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")

func add_trash_count():
	trash_qty -= 1
	$Songs/GetSound.play()
	TRASH_COUNT += 10
	$Background/Contador.set_count(str(TRASH_COUNT))
	if trash_qty == 0:
		_game_win()

func get_trash(_trash):
	get_sound()
	if _trash == actual_trash:
		$Trash/TrashTween.stop_all()
		var _idx = trash_array.find(actual_trash)
		trash_array.pop_at(_idx)
		actual_trash = null
		hide_crab()

func get_sound():
	$Songs/GetSound.play()

func _on_Trash_body_entered(body):
	if body.is_in_group('player'):
		body.free_trash()

func move_crab():
	var _idx = Global.random_int(0, len(trash_array) - 1)
	actual_trash = trash_array[_idx]
	$Crab/InitTween.interpolate_property(
		$Crab/Crab, "position",
		Vector2(actual_trash.position.x, position_out_screen),
		Vector2(actual_trash.position.x, actual_trash.position.y + position_offset),
		5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Crab/InitTween.start()

func _on_InitTween_tween_all_completed():
	$Crab/WaitTimer.start()

func _on_WaitTimer_timeout():
	$Crab/FinalTween.interpolate_property(
		$Crab/Crab, "position",
		$Crab/Crab.position,
		Vector2($Crab/Crab.position.x, position_out_screen),
		trash_transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	if actual_trash in trash_array:
		$Trash/TrashTween.interpolate_property(
			actual_trash, "position",
			actual_trash.position,
			Vector2(actual_trash.position.x, position_out_screen - position_offset),
			trash_transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Trash/TrashTween.start()
	$Crab/FinalTween.start()

func hide_crab():
	$Crab/FinalTween.stop_all()
	$Crab/HideTween.interpolate_property(
		$Crab/Crab, "position",
		$Crab/Crab.position,
		Vector2($Crab/Crab.position.x, position_out_screen),
		3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Crab/HideTween.start()

func _on_FinalTween_tween_all_completed():
	if actual_trash != null and actual_trash.position.y > 1800:
		var _idx = trash_array.find(actual_trash)
		trash_array.pop_at(_idx)
		actual_trash = null
		remove_trash_count()
	$Crab/SpawnTimer.start()

func remove_trash_count():
	$Songs/GetSound.play()
	TRASH_COUNT -= 10
	tries -= 1
	trash_qty -= 1
	$Tries/MarginContainer/LblTries.text = "INTENTOS: " + str(tries)
	$Background/Contador.set_count(str(TRASH_COUNT))
	if tries == 0:
		_game_over()
	elif trash_qty == 0:
		_game_win()

func _on_SpawnTimer_timeout():
	if not game_over:
		move_crab()

func _on_HideTween_tween_all_completed():
	$Crab/SpawnTimer.start()

func _game_win():
	game_over = true
	$HUD/Win.set_score(TRASH_COUNT)
	$HUD/Win.visible = true
	$Sounds/BGSong.stop()
	$Background/Ambience/IlleaCaminando.can_move = false

func _game_over():
	game_over = true
	$Songs/PunchSound.play()
	$HUD/GameOver.set_score(TRASH_COUNT)
	$HUD/GameOver.visible = true
	$Songs/BGSong.stop()
	$Background/Ambience/IlleaCaminando.can_move = false

func _on_try_again():
	get_tree().change_scene("res://Scenes/Games/LimpiandoCosta/Nivel2/LimpiandoCosta.tscn")
