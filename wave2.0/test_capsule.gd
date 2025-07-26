extends RigidBody3D

@export var float_force := 1.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/MAIN/Water')
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
var submerged := false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	submerged = false
	var depth = water.get_height(global_position) - global_position.y 
	if depth > 0:
		submerged = true
		apply_force(Vector3.UP * float_force * gravity * depth, global_position - global_position)
		
func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
