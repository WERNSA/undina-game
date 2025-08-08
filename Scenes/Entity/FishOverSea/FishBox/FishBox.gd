extends CharacterBody2D

const FLOOR = Vector2(0, -1)
@export var GRAVITY: int =  8
@export var SPEED: int = 300
@onready var motion = Vector2.ZERO
var can_move : bool = true

func _process(delta):
	motion_ctrl()

func get_axis() -> Vector2:
	var axis = Vector2.ZERO
#	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func motion_ctrl():
	if get_axis() == Vector2.ZERO:
		motion.y += GRAVITY
	elif can_move:
		motion = get_axis() * SPEED
	set_velocity(motion)
	set_up_direction(FLOOR)
	move_and_slide()
	motion = velocity
