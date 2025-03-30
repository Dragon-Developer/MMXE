//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D Palette;
uniform sampler2D original;

void main()
{
	vec4 putput = v_vColour * texture2D( original, v_vTexcoord );
	vec4 ref = texture2D(Palette, v_vTexcoord);
	if(ref.r == 1.0){
		putput = vec4(0.0,0.0,0.0,0.0);
	}
    gl_FragColor = putput;
}
