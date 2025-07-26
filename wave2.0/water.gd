extends MeshInstance3D
var material: ShaderMaterial
var noise: Image
var time: float
var height_scale: float
var noise_scale: float
var base_noise: float
var smallWaveAmp: float
var bigWaveAmp: float

func _ready():
	material = mesh.surface_get_material(0)
	noise = material.get_shader_parameter("noise").noise.get_seamless_image(512, 512)
	noise_scale = material.get_shader_parameter("noise_scale")
	height_scale = material.get_shader_parameter("height_scale");
	smallWaveAmp = material.get_shader_parameter("smallWaveAmp");
	bigWaveAmp = material.get_shader_parameter("bigWaveAmp");
	
func _process(delta):
	time += delta
	material.set_shader_parameter("wave_time", time)
	
func get_height(world_position: Vector3) -> float:
	var offset = Vector2(
		0.01 * cos(world_position.x + time),
		0.01 * cos(world_position.z + time)
	)
	var uv_x = wrapf(world_position.x / noise_scale - offset.x , 0, 1)
	var uv_y = wrapf(world_position.z / noise_scale - offset.y , 0, 1)
	var pixel_pos = Vector2(uv_x * noise.get_width(), uv_y * noise.get_height())
	base_noise = noise.get_pixelv(pixel_pos).r;
	# base_noise + smallWave Stuff
	base_noise += cos(world_position.z * 3.14 + time * 2.0) * smallWaveAmp
	# base_noise + bigWave Stuff
	base_noise += cos(world_position.z + time * 0.5) * bigWaveAmp
	return global_position.y + base_noise * height_scale;
