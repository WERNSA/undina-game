extends Node2D
var TRASH_COUNT = 0
@onready var trash_qty = 29
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
	Vector2(2900, 1900),
	Vector2(2900, 1700),
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
		"turtle": Vector2(475, 1400),
		"trash": Vector2(600, 1400),
	},
	{
		"turtle": Vector2(1175, 1200),
		"trash": Vector2(1300, 1200),
	},
	{
		"turtle": Vector2(675, 550),
		"trash": Vector2(800, 550),
	},
	{
		"turtle": Vector2(2125, 950),
		"trash": Vector2(2000, 950),
	},
	{
		"turtle": Vector2(2075, 1730),
		"trash": Vector2(2200, 1730),
	},
	{
		"turtle": Vector2(1425, 1730),
		"trash": Vector2(1550, 1730),
	},
	{
		"turtle": Vector2(225, 990),
		"trash": Vector2(350, 990),
	},
	{
		"turtle": Vector2(1325, 620),
		"trash": Vector2(1450, 620),
	},
	{
		"turtle": Vector2(2325, 580),
		"trash": Vector2(2450, 580),
	},
	{
		"turtle": Vector2(1175, 1750),
		"trash": Vector2(1300, 1750),
	},
	{
		"turtle": Vector2(725, 700),
		"trash": Vector2(600, 700),
	},
	{
		"turtle": Vector2(1725, 960),
		"trash": Vector2(1850, 960),
	},
	{
		"turtle": Vector2(725, 980),
		"trash": Vector2(600, 980),
	},
	{
		"turtle": Vector2(125, 540),
		"trash": Vector2(250, 540),
	},
	{
		"turtle": Vector2(925, 1030),
		"trash": Vector2(1050, 1030),
	},
	{
		"turtle": Vector2(925, 1540),
		"trash": Vector2(1050, 1540),
	},
	{
		"turtle": Vector2(2675, 810),
		"trash": Vector2(2800, 810),
	},
	{
		"turtle": Vector2(2375, 1180),
		"trash": Vector2(2500, 1180),
	},
	{
		"turtle": Vector2(2475, 1380),
		"trash": Vector2(2600, 1380),
	},
	{
		"turtle": Vector2(2175, 570),
		"trash": Vector2(2300, 570),
	},
	{
		"turtle": Vector2(2375, 1750),
		"trash": Vector2(2500, 1750),
	},
	{
		"turtle": Vector2(1325, 1330),
		"trash": Vector2(1450, 1330),
	},
	{
		"turtle": Vector2(2825, 1750),
		"trash": Vector2(2700, 1750),
	},
	{
		"turtle": Vector2(2475, 800),
		"trash": Vector2(2600, 800),
	},
	{
		"turtle": Vector2(725, 1430),
		"trash": Vector2(850, 1430),
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
	var _initial_pos_y = -200 if is_show else 0
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
	get_tree().change_scene_to_file("res://Scenes/Games/Pescando/Nivel2/Pescando.tscn")

func _on_CoralRockTimer_timeout():
	var pos = $Placeholder/CoralRock.position
	if pos == coral_rock_position["initial"][0]:
		move_coral_rock($Placeholder/CoralRock, coral_rock_position["initial"][0], coral_rock_position["final"][0])
		move_coral_rock($Placeholder/CoralRock2, coral_rock_position["initial"][1], coral_rock_position["final"][1])
	else:
		move_coral_rock($Placeholder/CoralRock, coral_rock_position["final"][0], coral_rock_position["initial"][0])
		move_coral_rock($Placeholder/CoralRock2, coral_rock_position["final"][1], coral_rock_position["initial"][1])

func move_coral_rock(_coral_rock, _initial_pos, _final_pos):
	$FishBG.create_tween().tween_property(
		_coral_rock, "position", _final_pos, 2
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
