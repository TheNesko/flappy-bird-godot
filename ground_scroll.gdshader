shader_type canvas_item;

uniform bool paused = true;
uniform float speed = 1.1;

void vertex() {
	if(paused == false){
		UV.x += TIME * speed;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
