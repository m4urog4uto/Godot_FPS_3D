extends CharacterBody3D

var health = 5
var moveSpeed = 1

var damage = 1
var attackRate = 1
var attackDist = 2

var givePoints = 10

@onready var player = get_tree().get_nodes_in_group("Player")[0] as Node3D
@onready var timer : Timer = $Timer

func _ready() -> void:
	timer.set_wait_time(attackRate)

func _physics_process(delta: float) -> void:
	# Aca obtenemos la distancia del enemigo con el jugador
	var dist = position.distance_to(player.position)
	
	# aca preguntamos si la distancia es mayor al ataque de distancia
	if dist > attackDist:
		# aca cargamos en una variable la distancia del jugador menos la del enemigo
		# normalize lo que hace es normalizar la magnitud igual a 1
		var dir = (player.position - position).normalized()
		# aca le agregamos velocidad
		velocity.x = dir.x * moveSpeed
		velocity.y = 0
		velocity.z = dir.z * moveSpeed
	else:
		velocity = Vector3.ZERO
		
	# aca hacemos que se mueva
	move_and_slide()

func take_damage(damage: int) -> void:
	health -= damage
	
	if health <= 0:
		die();

func die():
	player.add_score(givePoints)
	queue_free()
	
func attack():
	player.take_damage(damage)

func _on_timer_timeout() -> void:
	if position.distance_to(player.position) <= attackDist:
		attack()
