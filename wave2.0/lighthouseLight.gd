extends SpotLight3D
@export var speed = 1.0;

func _physics_process(delta):
	rotation.y += delta * speed;
