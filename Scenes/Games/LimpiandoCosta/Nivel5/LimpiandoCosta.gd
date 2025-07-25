extends Node2D

@onready var TRASH_COUNT := 0
var trash_array: Array
@onready var actual_trash: WeakRef = null
@onready var position_offset := 20
@onready var position_out_screen := 810 + position_offset
@onready var trash_transition_time := 15.0
@onready var game_over := false
@onready var tries := 3
var trash_qty: int
@onready var tween_trash : Tween
@onready var tween_crab : Tween

func _ready():
	randomize()
	$Background/Contador.set_count(str(TRASH_COUNT))
	trash_array = get_tree().get_nodes_in_group("enemy")
	trash_qty = trash_array.size()
	$Crab/SpawnTimer.start()
	$Tries/MarginContainer/LblTries.text = "iNTENTOS: " + str(tries)
	$HUD/GameOver/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)
	$HUD/Win/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)

func add_trash_count():
	trash_qty -= 1
	$Songs/GetSound.play()
	TRASH_COUNT += 10
	$Background/Contador.set_count(str(TRASH_COUNT))
	if trash_qty == 0:
		_game_win()

func get_trash(_trash):
	get_sound()
	if actual_trash and _trash == actual_trash.get_ref():
		actual_trash = null
		trash_array.erase(_trash)
		if tween_crab:
			tween_crab.kill()
		if tween_trash:
			tween_trash.kill()
		hide_crab()

func get_sound():
	$Songs/GetSound.play()

func _on_Trash_body_entered(body):
	if body.is_in_group("player"):
		body.free_trash()

func move_crab():
	if trash_array.is_empty():
		return
	var _idx = Global.random_int(0, trash_array.size() - 1)
	actual_trash = weakref(trash_array[_idx])
	var ref = actual_trash.get_ref()
	if ref:
		$Crab/Crab.position.x = ref.position.x
		tween_crab = create_tween()
		tween_crab.tween_property(
			$Crab/Crab, "position",
			Vector2(ref.position.x, ref.position.y + position_offset),
			3.0
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween_crab.finished.connect(_on_crab_arrived)

func _on_crab_arrived():
	$Crab/WaitTimer.start()

func _on_WaitTimer_timeout():
	tween_crab = create_tween()
	tween_crab.tween_property(
		$Crab/Crab, "position",
		Vector2($Crab/Crab.position.x, position_out_screen),
		trash_transition_time
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if actual_trash and actual_trash.get_ref() in trash_array:
		var ref = actual_trash.get_ref()
		tween_trash = create_tween()
		tween_trash.tween_property(
			ref, "position",
			Vector2(ref.position.x, position_out_screen - position_offset),
			trash_transition_time
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween_trash.finished.connect(_on_trash_fallen)

func hide_crab():
	tween_crab = create_tween()
	tween_crab.tween_property(
		$Crab/Crab, "position",
		Vector2($Crab/Crab.position.x, position_out_screen),
		3.0
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween_crab.finished.connect(_on_HideTween_tween_all_completed)

func _on_trash_fallen():
	if actual_trash and actual_trash.get_ref() and actual_trash.get_ref().position.y > 770:
		var ref = actual_trash.get_ref()
		trash_array.erase(ref)
		actual_trash = null
		remove_trash_count()
	$Crab/SpawnTimer.start()

func remove_trash_count():
	$Songs/GetSound.play()
	TRASH_COUNT -= 10
	tries -= 1
	trash_qty -= 1
	$Tries/MarginContainer/LblTries.text = "iNTENTOS: " + str(tries)
	$Background/Contador.set_count(str(TRASH_COUNT))
	if tries == 0:
		_game_over()
	elif trash_qty == 0:
		_game_win()

func _on_SpawnTimer_timeout():
	if not game_over and $Crab/Crab.position.y >= position_out_screen:
		move_crab()

func _on_HideTween_tween_all_completed():
	$Crab/SpawnTimer.start()

func _game_win():
	game_over = true
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$HUD/Win.set_score(TRASH_COUNT)
	$HUD/Win.visible = true
	$Songs/BGSong.stop()
	$Background/Ambience/IlleaCaminando.can_move = false

func _game_over():
	game_over = true
	$Songs/PunchSound.play()
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$HUD/GameOver.set_score(TRASH_COUNT)
	$HUD/GameOver.visible = true
	$Songs/BGSong.stop()
	$Background/Ambience/IlleaCaminando.can_move = false

func _on_try_again():
	get_tree().reload_current_scene()
