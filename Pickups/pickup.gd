extends Node3D

enum TypeObject {
	Ammo,
	Health
}

@export var object: TypeObject = TypeObject.Health
@export var give : int = 10

func _ready() -> void:
	pass

func _on_pickup_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name == "Player":
		pickup(body)
		queue_free()

func pickup(body):
	if object == TypeObject.Health:
		body.add_health(give)
	elif object == TypeObject.Ammo:
		body.add_ammo(give)
