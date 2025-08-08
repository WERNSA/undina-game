extends Area2D

@onready var is_eating : bool = false
@onready var _flip_h : bool = false
@onready var is_dead : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.flip_h = _flip_h
	if not is_dead:
		if is_eating:
			$AnimationPlayer.play("Eating")
		else:
			$AnimationPlayer.play("Idle")

func _set_eating(val):
	is_eating = val

func _set_dead(val):
	is_dead = val

func _set_flip_h(val):
	_flip_h = val
