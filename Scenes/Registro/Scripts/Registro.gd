extends Control

func _on_BtnLog_pressed():
	var player_name = $LineEdit.text.to_upper()
	Global.write_data(player_name)
	Global.player_name = player_name
	$LblDialog.text = "¡Hola " + player_name + """! Soy Ioni, gracias por 
	unirte a la misión de salvar los océanos juntos(as) lograremos que los 
	océanos de Marbella vuelvan a ser como antes."""
	$AnimationIllea.play("ShowIllea")

func _on_LineEdit_text_changed(_new_text):
	if $LineEdit.text != null and $LineEdit.text != "":
		$LogContainer/BtnLog.disabled = false
	else:
		$LogContainer/BtnLog.disabled = true

func _on_btnContinue_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Menu/Menu.tscn")
