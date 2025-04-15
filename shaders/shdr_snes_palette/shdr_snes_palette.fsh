varying vec2 v_vTexcoord;
uniform float PrecisionCutoff;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 usable = vec4(texColor.r * 255.0,texColor.g * 255.0,texColor.b * 255.0, texColor.a);
	vec4 lower = vec4(floor(usable.r / PrecisionCutoff),floor(usable.g / PrecisionCutoff),floor(usable.b / PrecisionCutoff),usable.a);
	vec4 higher = vec4(floor(lower.r * PrecisionCutoff),floor(lower.g * PrecisionCutoff),floor(lower.b * PrecisionCutoff),lower.a);
	vec4 finished = vec4(higher.r / 255.0,higher.g / 255.0,higher.b / 255.0, higher.a);
    gl_FragColor = vec4(finished.r,finished.g,finished.b, finished.a);
}