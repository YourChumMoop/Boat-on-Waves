shader_type spatial;
uniform sampler2D noise;
uniform float height_scale = 0.5;
uniform float wave_time = 0;
uniform float noise_scale = 10.0;
uniform float smallWaveAmp = 0.0;
uniform float bigWaveAmp = 0.0;

float height(vec2 position, float time){
  vec2 offset = 0.01 * cos(position + time);
  return texture(noise, (position / noise_scale) - offset).x * height_scale;
}

void vertex() {
  //float height = texture(noise, VERTEX.xz / 10.0 + 0.5).x;
  vec2 pos = VERTEX.xz;
  float k = height(pos, wave_time);
  //k += smallWave Stuff
  k += cos(VERTEX.z * 3.14 + wave_time * 2.0) * smallWaveAmp;
  //k += bigWave Stuff
  k += cos(VERTEX.z + wave_time * 0.5) * bigWaveAmp;
  VERTEX.y += k;
  NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), wave_time), 0.1, k - height(pos + vec2(0.0, 0.1), wave_time)));
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(0.1,0.3,0.5);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
