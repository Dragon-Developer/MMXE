//
// simple colour swapping fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float RainbowOffset;

void main()
{
    vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
    col.r=((col.r+col.g+col.b)/8.0 * sin(RainbowOffset + 3.1415 / 2.0 * 3.0))+0.53;
    col.g=((col.r+col.g+col.b)/8.0)+0.53;
    col.b=((col.r+col.g+col.b)/8.0 * sin(RainbowOffset + 3.1415 / 4.0 * 3.0))+0.53;
    gl_FragColor = v_vColour * col;
}

