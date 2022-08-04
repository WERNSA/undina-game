extends RigidBody2D
const GRAVITY =  16
onready var motion = Vector2.ZERO
const FLOOR = Vector2(0, -1)

#func _process(_delta):
#	motion_ctrl()
#
#func motion_ctrl():
#	motion.y += GRAVITY
#	motion = move_and_slide(motion)
