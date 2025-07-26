extends Camera3D

@export var target_node: Node3D
@export var look_node: Node3D
@export var look_node2: Node3D
@export var smooth_speed: float = 5.0

func _process(delta):
	if target_node:
		global_transform.origin = global_transform.origin.lerp(target_node.global_transform.origin, smooth_speed * delta * 0.1)
		# You can also interpolate rotation if needed
	if look_node and look_node2:
		var average_pos = (look_node.global_position + look_node2.global_position)/2
		average_pos = (average_pos + look_node.global_position)/2
		#global_transform.basis = global_transform.basis.slerp(target_node.global_transform.basis, smooth_speed * delta * 0.1)
		look_at(average_pos, Vector3.UP)
