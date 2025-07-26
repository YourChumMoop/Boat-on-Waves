extends RigidBody3D

@export var float_force := 1.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/MAIN/Water')
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@onready var probes = $ProbeContainer.get_children()

@export var max_speed: = 20.0
@export var acceleration: = 5.0
@export var deacceleration: = 8.0

var current_speed: = 0.0
var submerged := false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	
	var input_throttle: = Input.is_action_pressed("Throttle") # W
	var input_brake: = Input.is_action_pressed("Brake") # S
	var input_left: = Input.is_action_pressed("Left") # A
	var input_right: = Input.is_action_pressed("Right") # D
	if input_left:
			rotate_y(0.8 * delta)
	elif input_right:
			rotate_y(-0.8 * delta)
	if input_throttle:
		current_speed = min(current_speed + acceleration * delta, max_speed)
	elif input_brake:
		current_speed = max(current_speed - acceleration * delta, 0.0)
	else:
		current_speed = move_toward(current_speed, 0.0, deacceleration * delta)
	
	var direction: = -global_transform.basis.z.normalized()
	var movement:Vector3 = direction * current_speed * delta
	apply_central_force(direction * current_speed)
	

	
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)
		
func _integrate_forces(state: PhysicsDirectBodyState3D):
	var rotation_min = deg_to_rad(-45)
	var rotation_max = deg_to_rad(45)
	var new_rotation_z = clamp(rotation.z,rotation_min,rotation_max)
	var new_rotation_x = clamp(rotation.x,rotation_min,rotation_max)
	rotation.x = new_rotation_x
	rotation.z = new_rotation_z
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
