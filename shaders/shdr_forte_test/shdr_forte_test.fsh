//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float width;
uniform float height;
uniform float ScreenScale;

const vec3 size = vec3(285,285,1);//width,height,radius
const vec4 colOffset = vec4(0.0,-0.05,0.0, 0.0);//width,height,radius

const int Quality = 4;
const int Directions = 8;
const float Pi = 6.28318530718;//pi * 2

const float blendVal = 1.05;
const float cutoffVal = 0.05;
const float cutoffMult = 0.95;

vec4 apply_scanlines(vec4 val)
{
	vec4 ret = val;
	
	float mixVal = blendVal * abs((mod((v_vTexcoord.y * (height * ScreenScale)), ScreenScale)) - 1.0);
	//mixVal = mixVal * ((abs(mod((v_vTexcoord.x * (width * ScreenScale)), ScreenScale)) - 1.0) / 2.0 + 1.0);
	
	ret = vec4(ret.r / mixVal,ret.g / mixVal,ret.b / mixVal,1);
	
	return ret;
}

void main()
{
	
	vec2 radius = size.z/size.xy;
	vec2 offset = vec2(0.0,0.0);
	
	if(int(mod((v_vTexcoord.y * (height * ScreenScale)), ScreenScale)) <= 1){
		radius *= abs((mod((v_vTexcoord.y * (height * ScreenScale)), ScreenScale)) - 1.0) * 0.95 + 0.5;
	}
	
    vec4 Color = texture2D( gm_BaseTexture, v_vTexcoord + offset);
	vec4 temp = vec4(0.0,0.0,0.0,0.0);
	vec4 final = Color;
	
	offset.x -= ((Color.r + Color.g + Color.b) / width / 6.0);
	
    for( float d=0.0;d<Pi;d+=Pi/float(Directions) )
    {
        for( float i=1.0/float(Quality);i<=1.0;i+=1.0/float(Quality) )
        {
			temp = texture2D( gm_BaseTexture, v_vTexcoord+(vec2(cos(d),sin(d) * 0.1)*radius*i)+offset);
			temp *= sqrt((temp.r + temp.b + temp.g) / 45.0) + 0.9;
			Color += temp;
		}
    }
    Color /= float(Quality)*float(Directions)+1.0;
	
    final =  Color *  v_vColour;
	
	final = vec4((final.r - cutoffVal) * cutoffMult, (final.g - cutoffVal) * cutoffMult, (final.b - cutoffVal) * cutoffMult, 1);
	
	final = vec4(log(final.r + 1.0),log(final.g + 1.0),log(final.b + 1.0),1.0);
	
	final = apply_scanlines(final);
	
	final += colOffset;
	
	gl_FragColor = final;
}
