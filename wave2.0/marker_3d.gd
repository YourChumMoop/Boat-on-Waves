extends Marker3D
@onready var water = get_node('/root/MAIN/Water')

func _process(delta):
	print(water.get_height(global_position))
