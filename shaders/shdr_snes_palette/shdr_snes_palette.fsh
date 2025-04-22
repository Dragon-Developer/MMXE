/*varying vec2 v_vTexcoord;
uniform float PrecisionCutoff;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 usable = vec4(texColor.r * 255.0,texColor.g * 255.0,texColor.b * 255.0, texColor.a);
	vec4 lower = vec4(floor(usable.r / PrecisionCutoff),floor(usable.g / PrecisionCutoff),floor(usable.b / PrecisionCutoff),usable.a);
	vec4 higher = vec4(floor(lower.r * PrecisionCutoff),floor(lower.g * PrecisionCutoff),floor(lower.b * PrecisionCutoff),lower.a);
	vec4 finished = vec4(higher.r / 255.0,higher.g / 255.0,higher.b / 255.0, higher.a);
    gl_FragColor = vec4(finished.r,finished.g,finished.b, finished.a);
}*/
precision mediump float;
varying vec2 v_vTexcoord;

uniform float scale;
uniform float deviation;

// Because old GLSL does not support this out of the box.
float round(float val) {
    if (val - floor(val) >= 0.5) {
        return ceil(val);
    }
    return floor(val);
}

// We asume it's a 24 bit screen because modern PCs use that.
float to24bit(float val) {
    // We multiply by scale and add deviation.
    return floor(val * scale) + floor(val / deviation);
}

// Convert to the lower colospace as needed.
float toLowerBit(float val) {
    // Get deviation in 24-bit mode.
    float cdev = floor(floor(val / scale) / deviation);
    // Remove deviation, divide by scale and round.
    return round((val - cdev) / scale);
}

// Main function.
void main() {
    // Get frag color.
    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
    // First we find the closer X-bit val.
    // Then convert to 24-bit again.
	vec4 texColor = vec4(
	to24bit(toLowerBit(col.r * 255.0)) / 255.0,
	to24bit(toLowerBit(col.g * 255.0)) / 255.0,
	to24bit(toLowerBit(col.b * 255.0)) / 255.0,
	col.a);
    // Set frag color to the new value.
    gl_FragColor = texColor;
}
