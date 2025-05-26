extends Node2D
var muted : bool = false
@export var MuteOnImg: Texture2D
@export var MuteOffImg: Texture2D

func _on_btnExit_pressed():
	$SoundPress.play()
	$ConfirmExit.visible = true

func _on_btnYes_pressed():
	$SoundPress.play()
	get_tree().quit()

func _on_btnNo_pressed():
	$SoundPress.play()
	$ConfirmExit.visible = false

func _on_btnSettings_pressed():
	$SoundPress.play()
	$AudioSettings.visible = true

func _on_BtnBack_pressed():
	$SoundPress.play()
	$AudioSettings.visible = false

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

func _on_BtnMute_pressed():
	$SoundPress.play()
	if muted:
		$AudioSettings/SliderMusic.value = 0
		$AudioSettings/SliderSFX.value = 0
		$AudioSettings/SliderVoices.value = 0
		muted = false
		$AudioSettings/BtnMute.texture_normal = MuteOffImg
	else:
		$AudioSettings/SliderMusic.value = -40
		$AudioSettings/SliderSFX.value = -40
		$AudioSettings/SliderVoices.value = -40
		muted = true
		$AudioSettings/BtnMute.texture_normal = MuteOnImg


func _on_BtnAccept_pressed():
	$SoundPress.play()
	$AudioSettings.visible = false
