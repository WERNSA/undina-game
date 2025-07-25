extends Node2D

# Variables exportadas y globales
@export_file("*.json") var trivia_file: String
var TRIVIA_THEME
var actual_theme
var questions
var question_obj
var question_idx = 0
var question_qty = 0
var points := 0
var tries := 3
var game_over = false

func _ready():
	$Contador.set_count("0")
	$Roulette/AnimationPlayer.play("RESET")
	$GameOver/CenterContainer/HBoxContainer/BtnTry.connect("pressed", Callable(self, "_on_try_again"))
	$Win/CenterContainer/HBoxContainer/BtnTry.connect("pressed", Callable(self, "_on_try_again"))
	$Contador.set_count(str(points))
	$Timer/VBoxContainer/Tries/Label.text = "iNTENTOS: " + str(tries)
	questions = load_file()

func _process(_delta):
	$Timer/VBoxContainer/Timer/Label.text = Global.get_timer($Timer/Timer.time_left)

func _on_BtnLoop_pressed():
	$Sounds/SoundPress.play()
	var rand_theme: int = Global.random_int(1, 4)

	match rand_theme:
		1:
			TRIVIA_THEME = "Geografia"
			$Roulette/AnimationPlayer.play("RouletteGeografia")
			$Trivia/TitleGeografia.visible = true
		2:
			TRIVIA_THEME = "FloraFauna"
			$Roulette/AnimationPlayer.play("RouletteFloraFauna")
			$Trivia/TitleFloraFauna.visible = true
		3:
			TRIVIA_THEME = "Contaminacion"
			$Roulette/AnimationPlayer.play("RouletteContaminacion")
			$Trivia/TitleContaminacion.visible = true
		4:
			TRIVIA_THEME = "Reciclaje"
			$Roulette/AnimationPlayer.play("RouletteReciclaje")
			$Trivia/TitleReciclaje.visible = true

	actual_theme = questions[TRIVIA_THEME]
	actual_theme.shuffle()
	randomize()
	question_qty = actual_theme.size()

func _on_Timer_timeout():
	if $Timer/Timer.is_stopped():
		$Timer/Timer.start()
	$Roulette/AnimationPlayer.play("Trivia")
	load_question()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.begins_with("Roulette"):
		$Roulette/Timer.start()
	elif anim_name.to_lower().ends_with("correct"):
		$Roulette/AnimationPlayer.play("ResetOptions")
		$Dialog/Fence/Label.text = question_obj["long_answer"]
		$Dialog.visible = true
		$DialogBG.visible = true

func load_file() -> Variant:
	if not FileAccess.file_exists(trivia_file):
		push_error("Archivo no encontrado: " + trivia_file)
		return null

	var file = FileAccess.open(trivia_file, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parsed = JSON.parse_string(content)
		if parsed == null:
			push_error("Error al parsear el JSON.")
		return parsed
	else:
		push_error("No se pudo abrir el archivo.")
		return null

# --- NUEVO: Manejo de preguntas ---
func load_question():
	if (question_idx < question_qty and question_idx < 10):
		question_obj = actual_theme[question_idx]
		$Trivia/Question/Label.text = question_obj["title"]

		var shuffled_options = question_obj["options"].duplicate()
		shuffled_options.shuffle()
		question_obj["shuffled_options"] = shuffled_options

		$Trivia/Answers/Btn1/Option.text = shuffled_options[0]
		$Trivia/Answers/Btn2/Option.text = shuffled_options[1]
		$Trivia/Answers/Btn3/Option.text = shuffled_options[2]
	else:
		question_obj = null
		question_idx = 0
		$Roulette/AnimationPlayer.play("RESET")

# --- NUEVO: Validación genérica ---
func _on_answer_selected(button_index):
	disable_buttons(true)
	$Sounds/SoundPress.play()
	var selected_answer = question_obj["shuffled_options"][button_index]
	var correct_answer = question_obj["answer"]

	if selected_answer == correct_answer:
		$Trivia/Correct.get_node("CorrectOption" + str(button_index + 1) + "/Label").text = selected_answer
		$Trivia/Correct.get_node("CorrectOption" + str(button_index + 1)).visible = true
		$Roulette/AnimationPlayer.play("Correct")
		add_points()
	else:
		$Trivia/Incorrect.get_node("IncorrectOption" + str(button_index + 1) + "/Label").text = selected_answer
		$Trivia/Incorrect.get_node("IncorrectOption" + str(button_index + 1)).visible = true
		show_correct_answer()
		$Roulette/AnimationPlayer.play("Incorrect")
		remove_points()

func _on_Btn1_pressed(): _on_answer_selected(0)
func _on_Btn2_pressed(): _on_answer_selected(1)
func _on_Btn3_pressed(): _on_answer_selected(2)

func show_correct_answer():
	var shuffled = question_obj["shuffled_options"]
	var correct = question_obj["answer"]

	for i in shuffled.size():
		if shuffled[i] == correct:
			$Trivia/Correct.get_node("CorrectOption" + str(i + 1) + "/Label").text = correct
			$Trivia/Correct.get_node("CorrectOption" + str(i + 1)).visible = true
			break

func _on_btnContinue_pressed():
	$Sounds/SoundPress.play()
	$Dialog.visible = false
	$DialogBG.visible = false
	question_idx += 1
	load_question()
	disable_buttons(false)
	if tries <= 0:
		_game_over()

func add_points():
	points += 10
	$Contador.set_count(str(points))

func remove_points():
	points = max(points - 10, 0)
	tries -= 1
	$Timer/VBoxContainer/Tries/Label.text = "iNTENTOS: " + str(tries)
	$Contador.set_count(str(points))

func _game_win():
	game_over = true
	Global.player_points += points
	Global.write_points(points)
	$Win.set_score(points)
	$Win.visible = true
	$Sounds/BgSong.stop()

func _game_over():
	game_over = true
	Global.player_points += points
	Global.write_points(points)
	$GameOver.set_score(points)
	$GameOver.visible = true
	$Sounds/BgSong.stop()

func _on_try_again():
	get_tree().change_scene_to_file("res://Scenes/Games/Trivia/Trivia.tscn")

func _on_Timer_Timer_timeout():
	$Timer/Timer.stop()
	if points > 0:
		_game_win()
	else:
		_game_over()

func disable_buttons(val: bool):
	$Trivia/Answers/Btn1.disabled = val
	$Trivia/Answers/Btn2.disabled = val
	$Trivia/Answers/Btn3.disabled = val
