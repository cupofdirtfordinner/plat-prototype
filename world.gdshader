shader_type sky;
uniform vec3 skycolor : source_color;
void sky() {
	COLOR = skycolor;
}
