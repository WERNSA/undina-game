extends Control

func _on_btnExit_pressed():
	$AnimationConfirm.play("ConfirmExit")

func _on_btnYes_pressed():
	get_tree().quit()

func _on_btnNo_pressed():
	if $AnimationConfirm.current_animation:
		$AnimationConfirm.seek(0, true)
		$AnimationConfirm.stop()
