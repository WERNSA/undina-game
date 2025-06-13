extends Node2D
var TRASH_COUNT = 0
@onready var trash_qty = 30
@onready var tries = 3
@onready var game_over : bool = false
@onready var ilea_position = Vector2(1600, 600)
@export var FishBG: PackedScene

var coral_rock_position = {
	"initial": [
		Vector2(2650, 1250),
		Vector2(2500, 1450)
	],
	"final": [
		Vector2(2475, 1250),
		Vector2(2650, 1450)
	]
}

var fish_initial_positions = [
	Vector2(3500, 650),
	Vector2(3500, 850),
	Vector2(3500, 1050),
	Vector2(3500, 1250),
	Vector2(3500, 1450),
	Vector2(3500, 1650),
]
var fish_final_positions = [
	Vector2(-300, 650),
	Vector2(-300, 850),
	Vector2(-300, 1050),
	Vector2(-300, 1250),
	Vector2(-300, 1450),
	Vector2(-300, 1650),
]
var barracuda_position = [
	Vector2(2800, 1900),
	Vector2(2800, 1400),
]

@onready var turtle_position_idx : int = 0
@onready var actual_trash_position : Vector2 = Vector2.ZERO
var turtle_initial_position = [
	Vector2(1000, 1900),
	Vector2(2900, 1900),
	Vector2(1400, 1900)
]

var turtle_trash_position = [
	{
		"turtle": Vector2(575, 500),
		"trash": Vector2(700, 500),
	},
	{
		"turtle": Vector2(1550, 1310),
		"trash": Vector2(1550, 1310),
	},
	{
		"turtle": Vector2(1075, 1320),
		"trash": Vector2(1200, 1320),
	},
	{
		"turtle": Vector2(875, 820),
		"trash": Vector2(750, 820),
	},
	{
		"turtle": Vector2(375, 1650),
		"trash": Vector2(500, 1650),
	},
	{
		"turtle": Vector2(3025, 1000),
		"trash": Vector2(2900, 1000),
	},
	{
		"turtle": Vector2(375, 1310),
		"trash": Vector2(500, 1310),
	},
	{
		"turtle": Vector2(1275, 860),
		"trash": Vector2(1400, 860),
	},
	{
		"turtle": Vector2(3200, 820),
		"trash": Vector2(3075, 820),
	},
	{
		"turtle": Vector2(2725, 530),
		"trash": Vector2(2600, 530),
	},
	{
		"turtle": Vector2(2025, 1700),
		"trash": Vector2(1900, 1700),
	},
	{
		"turtle": Vector2(1125, 1670),
		"trash": Vector2(1000, 1670),
	},
	{
		"turtle": Vector2(1475, 1330),
		"trash": Vector2(1350, 1330),
	},
	{
		"turtle": Vector2(175, 1180),
		"trash": Vector2(300, 1180),
	},
	{
		"turtle": Vector2(1275, 1650),
		"trash": Vector2(1400, 1650),
	},
	{
		"turtle": Vector2(200, 900),
		"trash": Vector2(325, 900),
	},
	{
		"turtle": Vector2(2775, 1375),
		"trash": Vector2(2650, 1375),
	},
	{
		"turtle": Vector2(1675, 1320),
		"trash": Vector2(1800, 1320),
	},
	{
		"turtle": Vector2(575, 1325),
		"trash": Vector2(700, 1325),
	},
	{
		"turtle": Vector2(2575, 840),
		"trash": Vector2(2700, 840),
	},
	{
		"turtle": Vector2(2175, 1700),
		"trash": Vector2(2300, 1700),
	},
	{
		"turtle": Vector2(2025, 850),
		"trash": Vector2(1900, 850),
	},
	{
		"turtle": Vector2(2225, 1320),
		"trash": Vector2(2100, 1320),
	},
	{
		"turtle": Vector2(3075, 520),
		"trash": Vector2(2950, 520),
	},
	{
		"turtle": Vector2(2475, 520),
		"trash": Vector2(2350, 520),
	},
	{
		"turtle": Vector2(3125, 1300),
		"trash": Vector2(3000, 1300),
	},
	{
		"turtle": Vector2(2225, 650),
		"trash": Vector2(2100, 650),
	},
	{
		"turtle": Vector2(2475, 1320),
		"trash": Vector2(2350, 1320),
	},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Contador.set_count(str(TRASH_COUNT))
	$HUD/GameOver/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)
	$HUD/Win/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)

	spawn_fish_bg()
	$FishBG/SpawnFishBGTimer.start()
	$Fish/BarracudaTimer.start()
	move_barracuda()
	move_turtle()
	$Timer/MarginContainer/VBoxContainer/LblTries.text = "INTENTOS: " + str(tries)

func _physics_process(delta):
	var wave_velocity = 35
	get_node("Background/Wave").scroll_base_offset += Vector2(1, 0) * wave_velocity * delta
	$Timer/MarginContainer/VBoxContainer/LblTimer.text = Global.get_timer($Timer/Timer.time_left)

func add_trash_count():
	TRASH_COUNT += 10
	trash_qty -= 1
	$Contador.set_count(str(TRASH_COUNT))
	$Songs/GetSound.play()
	if trash_qty == 0:
		_game_win()

func get_sound():
	$Songs/GetSound.play()

func _on_SpawnFishBGTimer_timeout():
	spawn_fish_bg()

func spawn_fish_bg():
	var options_initial = Global.random_int(0, fish_initial_positions.size() - 1)
	var options_final = Global.random_int(0, fish_final_positions.size() - 1)
	var _position_initial = fish_initial_positions[options_initial]
	var _position_final = fish_final_positions[options_final]
	var fish_bg = FishBG.instantiate()
	fish_bg.position = _position_initial
	fish_bg.z_index = -1
	add_child(fish_bg)

	$FishBG.create_tween().tween_property(
		fish_bg, "position", _position_final, 10
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_BarracudaTimer_timeout():
	move_barracuda()

func move_barracuda():
	var target = barracuda_position[1] if $Fish/Barracuda.position == barracuda_position[0] else barracuda_position[0]
	$FishBG.create_tween().tween_property(
		$Fish/Barracuda, "position", target, 2
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func move_turtle():
	var _initial_position = turtle_initial_position[Global.random_int(0, turtle_initial_position.size() - 1)]
	turtle_position_idx = Global.random_int(0, turtle_trash_position.size() - 1)
	var _final_position = turtle_trash_position[turtle_position_idx]
	$FishBG/Turtle._set_flip_h(_initial_position.x > _final_position["turtle"].x)
	actual_trash_position = _final_position["trash"]

	$FishBG.create_tween().tween_property(
		$FishBG/Turtle, "position", _final_position["turtle"], 3
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_Timer_timeout():
	$Timer/Timer.stop()
	if not game_over:
		var _found = false
		var _trash
		for p in get_tree().get_nodes_in_group("enemy"):
			if p.position == actual_trash_position:
				_found = true
				_trash = p
				break
		if _found:
			$Songs/GetSound.play()
			_trash.queue_free()
			tries -= 1
			trash_qty -= 1
			TRASH_COUNT -= 10
			$Contador.set_count(str(TRASH_COUNT))
			$Timer/MarginContainer/VBoxContainer/LblTries.text = "INTENTOS: " + str(tries)
		if tries == 0:
			_game_over()
		elif trash_qty == 0:
			_game_win()
		else:
			hide_turtle()
		if $Timer.position.y != -200:
			show_timer(false)

func show_timer(is_show : bool):
	var _final_pos_y = 0 if is_show else -200

	$FishBG.create_tween().tween_property(
		$Timer, "position", Vector2(1600, _final_pos_y), 0.5
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$Timer/Timer.start()

func remove_trash_turtle(pos: Vector2):
	var _idx = 0
	var _found = false
	for p in turtle_trash_position:
		if p["trash"] == pos:
			_found = true
			break
		_idx += 1
	if _found:
		var trash_pos = turtle_trash_position.pop_at(_idx)
		if trash_pos["trash"] == actual_trash_position:
			if $Timer.position.y != -200:
				show_timer(false)
			hide_turtle()

func hide_turtle():
	$FishBG/Turtle._set_eating(false)
	var _initial_position = $FishBG/Turtle.position
	var _final_position = turtle_initial_position[Global.random_int(0, turtle_initial_position.size() - 1)]
	$FishBG/Turtle._set_flip_h(_initial_position.x > _final_position.x)

	$FishBG.create_tween().tween_property(
		$FishBG/Turtle, "position", _final_position, 3
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$FishBG/TurtleTimer.start()

func _on_TurtleTimer_timeout():
	move_turtle()

func _game_win():
	game_over = true
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$HUD/Win.set_score(TRASH_COUNT)
	$HUD/Win.visible = true
	$Sounds/BGSong.stop()
	$IlleaBuceando.can_move = false
	if $Timer.position.y != -200:
		show_timer(false)
	if turtle_initial_position.has($FishBG/Turtle.position):
		hide_turtle()

func _game_over():
	game_over = true
	$Songs/PunchSound.play()
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$HUD/GameOver.set_score(TRASH_COUNT)
	$HUD/GameOver.visible = true
	$Songs/BGSong.stop()
	$FishBG/Turtle._set_dead(true)
	$FishBG/Turtle/Sprite2D.flip_v = true

	$FishBG.create_tween().tween_property(
		$FishBG/Turtle, "position", Vector2($FishBG/Turtle.position.x, 400), 5
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$IlleaBuceando.can_move = false

func _on_try_again():
	get_tree().change_scene_to_file("res://Scenes/Games/Pescando/Nivel3/Pescando.tscn")
