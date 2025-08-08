extends Node2D

@export var RadarItem: PackedScene
@export var Fish: PackedScene
@export var Trash: PackedScene

var is_fishing: bool = false
var positions = [
	Vector2(280, 200),
	Vector2(150, 200),
	Vector2(250, 200),
	Vector2(100, 200),
	Vector2(120, 150),
	Vector2(250, 140),
	Vector2(220, 150),
	Vector2(280, 140),
	Vector2(250, 320),
	Vector2(120, 320),
	Vector2(200, 420),
]
var fishing_position_min = Vector2(1294, 520)
var fishing_position_max = Vector2(1294, 140)
var options: int = 0 # 0 => Fish || 1 => Trash
var points = 0
var TRASH_COUNT = 0
var tries = 3
var game_over: bool = false
var is_previous_fish : bool = false

var color_green = '#3ec91a'
var color_red = '#ff0e0e'
var positive_dialog = '¡HAY QUE PESCARLO!'
var negative_dialog = '¡NO HAY QUE PESCARLO!'

func _ready():
	randomize()
	$Characters/FishBox.visible = false
	$Characters/FishBox.can_move = false
	$GameOver/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)
	$Win/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)
	$Contador.set_count(str(TRASH_COUNT))

func set_dialog(_is_fishable):
	$Background/Dialog.visible = true
	if _is_fishable:
		$Background/Dialog/Label/Label.text = positive_dialog
		$Background/Dialog/Label/Label.add_theme_color_override("font_color", Color(color_green))
	else:
		$Background/Dialog/Label/Label.text = negative_dialog
		$Background/Dialog/Label/Label.add_theme_color_override("font_color", Color(color_red))

func _process(_delta):
	$Timer/VBoxContainer/Tries/Label.text = "iNTENTOS: " + str(tries)
	$Timer/VBoxContainer/Timer/Label.text = Global.get_timer($Timer/Timer.time_left)

func _on_RadarItemTimer_timeout():
	spawn_radar_item()

func spawn_radar_item():
	var position_index = Global.random_int(0, positions.size() - 1)
	var _position = positions[position_index]
	var radar_item = RadarItem.instantiate()
	radar_item.position = _position
	radar_item.z_index = 2
	add_child(radar_item)

func activate_fish():
	$Sensor/BtnFish.disabled = false

func deactivate_fish():
	$Sensor/BtnFish.disabled = true

func _on_BtnFish_pressed():
	if is_fishing:
		return
	$Sounds/SoundPress.play()
	$Sounds/SoundFish.play()
	$Sounds/SoundCatch.play()
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Characters/FishBox.can_move = true
	$Characters/FishBox.visible = true
	$Characters/FishBox.position.y = 340
	$Items/FishingRodLever/AnimationPlayer.play("Fishing")
	is_fishing = true
	points = 0
	spawn_fishing()

func _on_AnimationPlayer_animation_finished(anim_name):
	if is_fishing:
		$Items/FishingRodLever/AnimationPlayer.play("Fishing")

func spawn_fishing():
	options = Global.random_int(0, 6)
	var item
	if options <= 2 and not is_previous_fish:
		is_previous_fish = true
		item = Fish.instantiate()
		$Sensor/SliderPoints.max_value = 100
		$Sensor/PointsBar.max_value = 100
		$Characters/FishingTimer.wait_time = 15
		set_dialog(false)
	else:
		is_previous_fish = false
		item = Trash.instantiate()
		$Sensor/SliderPoints.max_value = 400
		$Sensor/PointsBar.max_value = 400
		$Characters/FishingTimer.wait_time = 15
		set_dialog(true)
	$Characters/FishingTimer.start()
	item.position = fishing_position_min
	item.z_index = 2
	add_child(item)

	var tween = get_tree().create_tween()
	tween.tween_property(item, "position", fishing_position_max, 2)
	tween.connect("finished", _on_Tween_tween_completed)

func _on_Tween_tween_completed():
	if is_fishing:
		var item_fishing = get_tree().get_nodes_in_group("item_fishing")
		if item_fishing.size() > 0:
			var new_position_y = Global.random_int(fishing_position_max.y, fishing_position_min.y)
			var tween = get_tree().create_tween()
			tween.tween_property(item_fishing[0], "position", Vector2(fishing_position_max.x, new_position_y), 2)
			tween.connect("finished", _on_Tween_tween_completed)

func _on_FishingTimer_timeout():
	stop_fishing()

func add_fishing_points():
	points += 1
	$Sensor/SliderPoints.value += 1
	$Sensor/PointsBar.value += 1
	if points >= $Sensor/SliderPoints.max_value:
		if options == 0:
			tries -= 1
			$Timer/VBoxContainer/Tries/Label.text = "iNTENTOS: " + str(tries)
			TRASH_COUNT -= 10
			$Contador.set_count(str(TRASH_COUNT))
			$Sounds/SoundSplash.play()
			$Sounds/PunchSound.play()
			$Characters/FishingTimer.stop()
			stop_fishing()
			if tries == 0:
				_game_over()
		else:
			TRASH_COUNT += 10
			$Sounds/SoundSplash.play()
			$Contador.set_count(str(TRASH_COUNT))
			$Characters/FishingTimer.stop()
			stop_fishing()

func stop_fishing():
	is_fishing = false
	$Background/Dialog.visible = false
	$Sounds/SoundCatch.stop()
	$Items/FishingRodLever/AnimationPlayer.play("RESET")
	$Characters/FishingRod.can_move = true
	$Characters/FishingRodItem.can_move = true
	$Characters/FishBox.can_move = false
	$Characters/FishBox.visible = false

	var radar_item = get_tree().get_nodes_in_group("radar_item")
	if radar_item.size() > 0:
		radar_item[0].queue_free()
	var item_fishing = get_tree().get_nodes_in_group("item_fishing")
	if item_fishing.size() > 0:
		item_fishing[0].queue_free()

	if tries != 0:
		spawn_radar_item()

	$Sensor/SliderPoints.value = 0
	$Sensor/PointsBar.value = 0

func _game_over():
	$Timer/Timer.stop()
	game_over = true
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$GameOver.set_score(TRASH_COUNT)
	$GameOver.visible = true
	$Characters/FishBox.can_move = false
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Sounds/BGSong.stop()

func _game_win():
	game_over = true
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$Win.set_score(TRASH_COUNT)
	$Win.visible = true
	$Characters/FishBox.can_move = false
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Sounds/BGSong.stop()

func _on_try_again():
	get_tree().change_scene_to_file("res://Scenes/Games/PescaSobreAgua/Nivel1/PescaSobreAgua.tscn")

func _on_Timer_timeout():
	$Timer/Timer.stop()
	if TRASH_COUNT > 0:
		_game_win()
	else:
		_game_over()


func _on_bg_song_finished() -> void:
	$Sounds/BGSong.play()
