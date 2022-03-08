extends Node2D

func _ready():
	$Contador.set_count("0")	
	$Roulette/AnimationPlayer.play("RESET")

func _on_BtnLoop_pressed():
	$Roulette/AnimationPlayer.play("Roulette")


func _on_Timer_timeout():
	$Roulette/AnimationPlayer.play("Geografia")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Roulette":
		$Roulette/Timer.start()


func _on_BtnCorrect_pressed():
	$Roulette/AnimationPlayer.play("Correct")
	$Contador.set_count("10")
