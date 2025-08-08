extends Area2D
@onready var level = get_tree().get_nodes_in_group("sea_fish_level")[0]

func _on_RadarItem_body_entered(body):
	if body.is_in_group('player'):
		$AnimationPlayer.play("Active")
		level.activate_fish()


func _on_RadarItem_body_exited(body):
	if body.is_in_group('player'):
		$AnimationPlayer.play("RESET")
		level.deactivate_fish()
