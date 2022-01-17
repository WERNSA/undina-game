extends Control
var muted : bool = false

func _on_btnExit_pressed():
	$AnimationConfirm.play("ConfirmExit")

func _on_btnYes_pressed():
	get_tree().quit()

func _on_btnNo_pressed():
	$AnimationConfirm.play("CloseMenu")


func _on_btnSettings_pressed():
	$AnimationConfirm.play("AudioSettings")


func _on_BtnBack_pressed():
	$AnimationConfirm.play("CloseMenu")


func _on_SliderMusic_value_changed(value):
	var value_sound = value
	if value <= -40:
		value_sound = -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value_sound)


func _on_SliderVoices_value_changed(value):
	var value_sound = value
	if value <= -40:
		value_sound = -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voices"), value_sound)


func _on_SliderSFX_value_changed(value):
	var value_sound = value
	if value <= -40:
		value_sound = -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value_sound)


func _on_Button_pressed():
	if muted:
		$AudioSettings/SliderMusic.value = 0
		$AudioSettings/SliderSFX.value = 0
		$AudioSettings/SliderVoices.value = 0
		muted = false
	else:
		$AudioSettings/SliderMusic.value = -40
		$AudioSettings/SliderSFX.value = -40
		$AudioSettings/SliderVoices.value = -40
		muted = true
