extends CharacterBody3D

# Stats
var health : int = 10
var maxHealth : = 10
var ammo : int = 5
var score : int = 15

# Physics
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Camera
var minLookAngle : float = -90.0
var maxLookAngle : float = 90
var cameraSens : float = .2

# vectors
var mouseDelta : Vector2 = Vector2()

#camera
@onready var cam = $CameraOrbit/Camera3D
@onready var bulletPivot = $CameraOrbit/Camera3D/gun/BulletPivot

# Preload lo que hace es precargar la escena en memoria de la bala cuando el jugador tambien se cargue
@onready var bulletScene = preload("res://Bullet/bullet.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# mover con el mouse
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# aca rotamos al personaje
		rotate_y(deg_to_rad(-event.relative.x * cameraSens))
		
		# aca rotamos la camara
		cam.rotate_x(deg_to_rad(-event.relative.y * cameraSens))
		# El clamp sirve para limitar  el movimiento de la camara al rotarla.
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
	# Salimos del juego si toca escape
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _process(_delta: float) -> void:
	#Rotar la camara en el eje X
	cam.rotation_degrees -= Vector3()
	
	if Input.is_action_just_pressed("shoot"):
		shooting()

func shooting():
	if ammo != 0:
		var bulletInstanse = bulletScene.instantiate()
		bulletInstanse.global_transform = bulletPivot.global_transform
		bulletInstanse.scale = Vector3.ONE
		get_tree().current_scene.add_child(bulletInstanse)
		ammo -= 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("d", "a", "s", "w")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func add_score(givePoints):
	score += givePoints
	
func take_damage(damage):
	health -= damage
	
	if health <= 0:
		die()

func die():
	get_tree().reload_current_scene()
	
func add_health(extraHealth):
	health = clamp(health + extraHealth, 0, maxHealth)

func add_ammo(extraAmmo):
	ammo += extraAmmo
