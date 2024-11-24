extends Area3D

var speed : float = 30.0
var damage : int = 1
var direction : Vector3 = Vector3.ZERO

var velocity: Vector3

func _ready() -> void:
	velocity += transform.basis.z * speed

# En process movemos la bala hacia adelante
func _process(delta: float) -> void:
	global_transform.origin += velocity * delta

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
		
func destroy():
	queue_free()

func _on_destroy_timer_timeout() -> void:
	destroy()
