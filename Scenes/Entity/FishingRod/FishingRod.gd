extends KinematicBody2D

export var SPEED : int = 150
# EL ONREADY ES COMO DECLARARLA EN LA FUNCION READY
onready var motion = Vector2.ZERO # ESTA PROP DEL VECTOR ES LO MISMO QUE (0,0)
onready var can_move : bool = true
onready var screensize = get_viewport_rect().size # tamaño de la ventana

func _physics_process(delta):
	if can_move:
		motion_ctrl()
		motion = move_and_collide(motion * delta)

""" función para definir el movimiento del player """
func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func motion_ctrl(): # Controlador de Movimiento
	if get_axis() == Vector2.ZERO:
		$SoundMove.stop()
		motion = Vector2.ZERO
		$Particles2D.position.x = -60
		$Particles2D.position.y = 0
		$Particles2D.rotation_degrees = 0
	else:
		if not $SoundMove.playing:
			$SoundMove.play()
		motion = get_axis().normalized() * SPEED
		if get_axis().x == 1 and get_axis().y == 0:
			$Particles2D.position.x = -60
			$Particles2D.position.y = 0
			$Particles2D.rotation_degrees = 0
		elif get_axis().x == 1 and get_axis().y == 1:
			$Particles2D.position.x = -60
			$Particles2D.position.y = -60
			$Particles2D.rotation_degrees = 45
		elif get_axis().x == 1 and get_axis().y == -1:
			$Particles2D.position.x = -56
			$Particles2D.position.y = 56
			$Particles2D.rotation_degrees = -45
		elif get_axis().x == -1 and get_axis().y == 0:
			$Particles2D.position.x = 70
			$Particles2D.position.y = 0
			$Particles2D.rotation_degrees = 180
		elif get_axis().x == -1 and get_axis().y == -1:
			$Particles2D.position.x = 56
			$Particles2D.position.y = 56
			$Particles2D.rotation_degrees = 225
		elif get_axis().x == -1 and get_axis().y == 1:
			$Particles2D.position.x = 60
			$Particles2D.position.y = -60
			$Particles2D.rotation_degrees = 135
		elif get_axis().x == 0 and get_axis().y == 1:
			$Particles2D.position.x = 0
			$Particles2D.position.y = -70
			$Particles2D.rotation_degrees = 90
		elif get_axis().x == 0 and get_axis().y == -1:
			$Particles2D.position.x = 0
			$Particles2D.position.y = 70
			$Particles2D.rotation_degrees = 270
		else:
			$Particles2D.position.x = -60
			$Particles2D.position.y = 0
			$Particles2D.rotation_degrees = 0
	
	# Limitar el movimiento del personaje
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
