extends Node2D
var TRIVIA_THEME
onready var question_idx = 0
onready var points = 0
onready var question_qty = 0
var question_obj
export(String, FILE, "*.json") var trivia_file
onready var TRIVIA_POINTS = 0
onready var tries = 3
onready var game_over : bool = false
onready var is_correct : bool = true
var questions
var actual_theme

func _ready():
	$Contador.set_count("0")
	$Roulette/AnimationPlayer.play("RESET")
	$GameOver/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$Win/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$Contador.set_count(str(TRIVIA_POINTS))
	$Timer/VBoxContainer/Tries/Label.text = "INTENTOS: " + str(tries)
	questions = load_file()

func _process(_delta):
	$Timer/VBoxContainer/Timer/Label.text = Global.get_timer($Timer/Timer.time_left)

func _on_BtnLoop_pressed():
	$Sounds/SoundPress.play()
	var rand_theme : int = Global.random_int(1, 4)
	match rand_theme:
		1:
			$Roulette/AnimationPlayer.play("RouletteGeografia")
			TRIVIA_THEME = "Geografia"
			$Trivia/TitleGeografia.visible = true
		2:
			$Roulette/AnimationPlayer.play("RouletteFloraFauna")
			TRIVIA_THEME = "FloraFauna"
			$Trivia/TitleFloraFauna.visible = true
		3:
			$Roulette/AnimationPlayer.play("RouletteContaminacion")
			TRIVIA_THEME = "Contaminacion"
			$Trivia/TitleContaminacion.visible = true
		4:
			$Roulette/AnimationPlayer.play("RouletteReciclaje")
			TRIVIA_THEME = "Reciclaje"
			$Trivia/TitleReciclaje.visible = true
	actual_theme = questions[TRIVIA_THEME]
	randomize()
	actual_theme.shuffle()
	question_qty = questions[TRIVIA_THEME].size()

func _on_Timer_timeout():
	$Roulette/AnimationPlayer.play("Trivia")
	load_questions()

func _on_AnimationPlayer_animation_finished(anim_name):
	if str(anim_name).begins_with("Roulette"):
		$Roulette/Timer.start()
	elif str(anim_name).to_lower().ends_with("correct"):
		$Roulette/AnimationPlayer.play("ResetOptions")
		$Dialog/Fence/Label.text = question_obj["long_answer"]
		$Dialog.visible = true
		$DialogBG.visible = true

func load_file():
	var file = File.new()
	if file.file_exists(trivia_file):
		file.open(trivia_file, file.READ)
		return parse_json(file.get_as_text())

func _on_Btn1_pressed():
	$Sounds/SoundPress.play()
	var answer = question_obj["options"][0]
	var is_correct : bool = question_obj["answer"] == answer
	if is_correct:
		$Trivia/Correct/CorrectOption1/Label.text = answer
		$Trivia/Correct/CorrectOption1.visible = true
		$Roulette/AnimationPlayer.play("Correct")
		add_points()
	else:
		$Trivia/Incorrect/IncorrectOption1/Label.text = answer
		$Trivia/Incorrect/IncorrectOption1.visible = true
		show_answer()
		$Roulette/AnimationPlayer.play("Incorrect")
		remove_points()

func _on_Btn2_pressed():
	$Sounds/SoundPress.play()
	var answer = question_obj["options"][1]
	var is_correct : bool = question_obj["answer"] == answer
	if is_correct:
		$Trivia/Correct/CorrectOption2/Label.text = answer
		$Trivia/Correct/CorrectOption2.visible = true
		$Roulette/AnimationPlayer.play("Correct")
		add_points()
	else:
		$Trivia/Incorrect/IncorrectOption2/Label.text = answer
		$Trivia/Incorrect/IncorrectOption2.visible = true
		show_answer()
		$Roulette/AnimationPlayer.play("Incorrect")
		remove_points()

func _on_Btn3_pressed():
	$Sounds/SoundPress.play()
	var answer = question_obj["options"][2]
	var is_correct : bool = question_obj["answer"] == answer
	if is_correct:
		$Trivia/Correct/CorrectOption3/Label.text = answer
		$Trivia/Correct/CorrectOption3.visible = true
		$Roulette/AnimationPlayer.play("Correct")
		add_points()
	else:
		$Trivia/Incorrect/IncorrectOption3/Label.text = answer
		$Trivia/Incorrect/IncorrectOption3.visible = true
		show_answer()
		$Roulette/AnimationPlayer.play("Incorrect")
		remove_points()

func load_questions():
	if (question_idx + 1 <= question_qty or question_qty == 0) and question_idx < 10:		
		question_obj = actual_theme[question_idx]
		$Trivia/Question/Label.text = question_obj["title"]
		$Trivia/Answers/Btn1/Option.text = question_obj["options"][0]
		$Trivia/Answers/Btn2/Option.text = question_obj["options"][1]
		$Trivia/Answers/Btn3/Option.text = question_obj["options"][2]
	else:
		$Roulette/AnimationPlayer.play("RESET")
		question_idx = 0
		question_obj = null

func add_points():
	points += 10
	$Contador.set_count(str(points))

func remove_points():
	points -= 10
	tries -= 1
	$Timer/VBoxContainer/Tries/Label.text = "INTENTOS: " + str(tries)
	$Contador.set_count(str(points))

func show_answer():
	var option1 = question_obj["options"][0]
	var option2 = question_obj["options"][1]
	var answer = question_obj["answer"]
	
	if option1 == answer:
		$Trivia/Correct/CorrectOption1/Label.text = answer
		$Trivia/Correct/CorrectOption1.visible = true
	elif option2 == answer:
		$Trivia/Correct/CorrectOption2/Label.text = answer
		$Trivia/Correct/CorrectOption2.visible = true
	else:
		$Trivia/Correct/CorrectOption3/Label.text = answer
		$Trivia/Correct/CorrectOption3.visible = true

func _on_btnContinue_pressed():
	$Sounds/SoundPress.play()
	$Dialog.visible = false
	$DialogBG.visible = false
	question_idx += 1
	load_questions()
	if tries == 0:
		_game_over()

func _game_win():
	game_over = true
	$Win.set_score(TRIVIA_POINTS)
	$Win.visible = true
	$Sounds/BgSong.stop()

func _game_over():
	game_over = true
	$GameOver.set_score(TRIVIA_POINTS)
	$GameOver.visible = true
	$Sounds/BgSong.stop()

func _on_try_again():
	TRIVIA_POINTS = 0
	$Contador.set_count(str(TRIVIA_POINTS))
	tries = 3
	$Timer/VBoxContainer/Tries/Label.text = "INTENTOS: " + str(tries)
	game_over = false
	$GameOver.visible = false
	$Win.visible = false
	$Sounds/BgSong.play()
	$Timer/Timer.start()
	$Roulette/AnimationPlayer.play("RESET")

func _on_Timer_Timer_timeout():
	$Timer/Timer.stop()
	if TRIVIA_POINTS > 0:
		_game_win()
	else:
		_game_over()
