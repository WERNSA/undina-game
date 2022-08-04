extends Node2D
export(PackedScene) var RadarItem
export(PackedScene) var Fish
export(PackedScene) var Trash
onready var is_fishing : bool = false
var positions = [
	Vector2(450, 450),
	Vector2(550, 450),
	Vector2(300, 450),
	Vector2(300, 650),
	Vector2(550, 650),
	Vector2(450, 800),
	Vector2(350, 800),
	Vector2(550, 800),
	Vector2(450, 900),
	Vector2(350, 900),
	Vector2(450, 1000),
]
var fishing_position_min = Vector2(3023, 1340)
var fishing_position_max = Vector2(3023, 350)
onready var options : int = 0 # 0 => Fish || 1 => Trash
var points = 0
var TRASH_COUNT = 0
onready var tries = 3
onready var game_over : bool = false
onready var FishingRodPosition = Vector2(1100, 450)
onready var FishingRodItemPosition = Vector2(450, 650)
onready var FishBoxPosition = Vector2(3020, 850)

func _ready():
	$Characters/FishBox.visible = false
	$Characters/FishBox.can_move = false
	$GameOver/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$Win/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$Contador.set_count(str(TRASH_COUNT))

func _process(_delta):
	$Timer/MarginContainer/Label.text = Global.get_timer($Timer/Timer.time_left)

func _on_RadarItemTimer_timeout():
	spawn_radar_item()

func spawn_radar_item():
	var position_index = Global.random_int(0, len(positions) - 1)
	var _position = positions[position_index]
	var radar_item = RadarItem.instance()
	radar_item.position = _position
	radar_item.z_index = 2
	add_child(radar_item)

func activate_fish():
	$Sensor/BtnFish.disabled = false

func deactivate_fish():
	$Sensor/BtnFish.disabled = true

func _on_BtnFish_pressed():
	$Sounds/SoundPress.play()
	$Sounds/SoundFish.play()
	$Sounds/SoundCatch.play()
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Characters/FishBox.can_move = true
	$Characters/FishBox.visible = true
	$Characters/FishBox.position.y = 850
	$Items/FishingRodLever/AnimationPlayer.play("Fishing")
	is_fishing = true
	points = 0
	spawn_fishing()

func _on_AnimationPlayer_animation_finished(anim_name):
	if is_fishing:
		$Items/FishingRodLever/AnimationPlayer.play("Fishing")

func spawn_fishing():
	options = Global.random_int(0, 1)
	var item
	if options == 0:
		item = Fish.instance()
		$Sensor/SliderPoints.max_value = 100
		$Characters/FishingTimer.wait_time = 15
	else:
		item = Trash.instance()
		$Sensor/SliderPoints.max_value = 400
		$Characters/FishingTimer.wait_time = 10
	$Characters/FishingTimer.start()
	item.position = fishing_position_min
	item.z_index = 2
	add_child(item)
	$Characters/Tween.interpolate_property(item, "position",
		fishing_position_min, fishing_position_max, 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Characters/Tween.start()

func _on_Tween_tween_completed(object, key):
	if is_fishing:
		var item_fishing = get_tree().get_nodes_in_group("item_fishing")[0]
		var new_position_y = Global.random_int(350, 1340)
		$Characters/Tween.interpolate_property(item_fishing, "position",
		item_fishing.position, Vector2(fishing_position_max.x, new_position_y), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Characters/Tween.start()

func _on_FishingTimer_timeout():
	stop_fishing()

func add_fishing_points():
	points += 1
	$Sensor/SliderPoints.value += 1
	if points >= $Sensor/SliderPoints.max_value:
		if options == 0:
			tries -= 1
			TRASH_COUNT = TRASH_COUNT - 10
			$Contador.set_count(str(TRASH_COUNT))
			$Sounds/SoundSplash.play()
			$Characters/FishingTimer.stop()
			stop_fishing()
			if tries == 0:
				_game_over()
		else:
			TRASH_COUNT = TRASH_COUNT + 10
			$Sounds/SoundSplash.play()
			$Contador.set_count(str(TRASH_COUNT))
			$Characters/FishingTimer.stop()
			stop_fishing()

func stop_fishing():
	is_fishing = false
	$Sounds/SoundCatch.stop()
	$Items/FishingRodLever/AnimationPlayer.play("RESET")
	$Characters/Tween.stop_all()
	$Characters/FishingRod.can_move = true
	$Characters/FishingRodItem.can_move = true
	$Characters/FishBox.can_move = false
	$Characters/FishBox.visible = false
	var radar_item = get_tree().get_nodes_in_group("radar_item")
	if radar_item:
		radar_item[0].queue_free()
	var item_fishing = get_tree().get_nodes_in_group("item_fishing")
	if item_fishing:
		item_fishing[0].queue_free()
	if tries != 0:
		spawn_radar_item()
	$Sensor/SliderPoints.value = 0

func _game_over():
	$Timer/Timer.stop()
	game_over = true
	$GameOver.set_score(TRASH_COUNT)
	$GameOver.visible = true
	$Characters/FishBox.can_move = false
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Sounds/BGSong.stop()

func _game_win():
	game_over = true
	$Win.set_score(TRASH_COUNT)
	$Win.visible = true
	$Characters/FishBox.can_move = false
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Sounds/BGSong.stop()

func _on_try_again():
	TRASH_COUNT = 0
	$Contador.set_count(str(TRASH_COUNT))
	tries = 3
	game_over = false
	$GameOver.visible = false
	$Win.visible = false
	$Characters/FishBox.can_move = false
	$Characters/FishingRod.can_move = false
	$Characters/FishingRodItem.can_move = false
	$Characters/FishBox.position = FishBoxPosition
	$Characters/FishingRod.position = FishingRodPosition
	$Characters/FishingRodItem.position = FishingRodItemPosition
	$Sounds/BGSong.play()
	$Timer/Timer.start()
	stop_fishing()


func _on_Timer_timeout():
	$Timer/Timer.stop()
	if TRASH_COUNT > 0:
		_game_win()
	else:
		_game_over()
