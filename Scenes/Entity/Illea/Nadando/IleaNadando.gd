extends CharacterBody2D

const SPEED = 300
# EL ONREADY ES COMO DECLARARLA EN LA FUNCION READY
@onready var motion = Vector2.ZERO # ESTA PROP DEL VECTOR ES LO MISMO QUE (0,0)
@onready var can_move : bool = true
@onready var screensize = get_viewport_rect().size # tamaño de la ventana
@onready var is_punch : bool = false


func _physics_process(delta):
	if can_move:
		motion_ctrl()
		animation_ctrl()
		motion = move_and_collide(motion * delta)

""" función para definir el movimiento del player """
func get_axis() -> Vector2:
	var axis = Vector2.ZERO
#	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func motion_ctrl(): # Controlador de Movimiento
	if get_axis() == Vector2.ZERO:
		motion = Vector2.ZERO
	else:
		motion = get_axis().normalized() * SPEED
	
	# Limitar el movimiento del personaje
#	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

func animation_ctrl(): #Controlador de Animaciones
	if can_move:
		if is_punch:
			$AnimationPlayer.play("Punch")
		else:
			$AnimationPlayer.play("Swim")

func _on_BGSound_finished():
	if can_move:
		$BGSound.play()

func _on_InvisibiltyTimer_timeout():
	$CollisionShape2D.disabled = false
	is_punch = false

func punch_ctrl():
	$CollisionShape2D.disabled = true
	$InvisibiltyTimer.start()
	is_punch = true
