varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//  Get palette as texture
uniform sampler2D Palette;

//  Color Offset Index
uniform float Offset;
//  Source
uniform float OffsetSource;

uniform float RedColorsBase[32];// 32 for wiggle room. also because of psx sprites
uniform float GreenColorsBase[32];
uniform float BlueColorsBase[32];

uniform float RedColorsSwap[32];
uniform float GreenColorsSwap[32];
uniform float BlueColorsSwap[32];

vec4 shittyFindColorFunction(){
    vec4 ref = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 ver = vec4(RedColorsBase[0],GreenColorsBase[0],BlueColorsBase[0],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[0],GreenColorsSwap[0],BlueColorsSwap[0],1.0);
	}
	ver = vec4(RedColorsBase[1],GreenColorsBase[1],BlueColorsBase[1],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[1],GreenColorsSwap[1],BlueColorsSwap[1],1.0);
	}
	ver = vec4(RedColorsBase[2],GreenColorsBase[2],BlueColorsBase[2],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[2],GreenColorsSwap[2],BlueColorsSwap[2],1.0);
	}
	ver = vec4(RedColorsBase[3],GreenColorsBase[3],BlueColorsBase[3],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[3],GreenColorsSwap[3],BlueColorsSwap[3],1.0);
	}
	ver = vec4(RedColorsBase[4],GreenColorsBase[4],BlueColorsBase[4],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[4],GreenColorsSwap[4],BlueColorsSwap[4],1.0);
	}
	ver = vec4(RedColorsBase[5],GreenColorsBase[5],BlueColorsBase[5],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[5],GreenColorsSwap[5],BlueColorsSwap[5],1.0);
	}
	ver = vec4(RedColorsBase[6],GreenColorsBase[6],BlueColorsBase[6],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[6],GreenColorsSwap[6],BlueColorsSwap[6],1.0);
	}
	ver = vec4(RedColorsBase[7],GreenColorsBase[7],BlueColorsBase[7],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[7],GreenColorsSwap[7],BlueColorsSwap[7],1.0);
	}
	ver = vec4(RedColorsBase[8],GreenColorsBase[8],BlueColorsBase[8],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[8],GreenColorsSwap[8],BlueColorsSwap[8],1.0);
	}
	ver = vec4(RedColorsBase[9],GreenColorsBase[9],BlueColorsBase[9],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[9],GreenColorsSwap[9],BlueColorsSwap[9],1.0);
	}
	ver = vec4(RedColorsBase[10],GreenColorsBase[10],BlueColorsBase[10],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[10],GreenColorsSwap[10],BlueColorsSwap[10],1.0);
	}
	ver = vec4(RedColorsBase[11],GreenColorsBase[11],BlueColorsBase[11],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[11],GreenColorsSwap[11],BlueColorsSwap[11],1.0);
	}
	ver = vec4(RedColorsBase[12],GreenColorsBase[12],BlueColorsBase[12],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[12],GreenColorsSwap[12],BlueColorsSwap[12],1.0);
	}
	ver = vec4(RedColorsBase[13],GreenColorsBase[13],BlueColorsBase[13],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[13],GreenColorsSwap[13],BlueColorsSwap[13],1.0);
	}
	ver = vec4(RedColorsBase[14],GreenColorsBase[14],BlueColorsBase[14],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[14],GreenColorsSwap[14],BlueColorsSwap[14],1.0);
	}
	ver = vec4(RedColorsBase[15],GreenColorsBase[15],BlueColorsBase[15],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[15],GreenColorsSwap[15],BlueColorsSwap[15],1.0);
	}
	ver = vec4(RedColorsBase[16],GreenColorsBase[16],BlueColorsBase[16],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[16],GreenColorsSwap[16],BlueColorsSwap[16],1.0);
	}
	ver = vec4(RedColorsBase[17],GreenColorsBase[17],BlueColorsBase[17],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[17],GreenColorsSwap[17],BlueColorsSwap[17],1.0);
	}
	ver = vec4(RedColorsBase[18],GreenColorsBase[18],BlueColorsBase[18],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[18],GreenColorsSwap[18],BlueColorsSwap[18],1.0);
	}
	ver = vec4(RedColorsBase[19],GreenColorsBase[19],BlueColorsBase[19],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[19],GreenColorsSwap[19],BlueColorsSwap[19],1.0);
	}
	ver = vec4(RedColorsBase[20],GreenColorsBase[20],BlueColorsBase[20],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[20],GreenColorsSwap[20],BlueColorsSwap[20],1.0);
	}
	ver = vec4(RedColorsBase[21],GreenColorsBase[21],BlueColorsBase[21],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[21],GreenColorsSwap[21],BlueColorsSwap[21],1.0);
	}
	ver = vec4(RedColorsBase[22],GreenColorsBase[22],BlueColorsBase[22],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[22],GreenColorsSwap[22],BlueColorsSwap[22],1.0);
	}
	ver = vec4(RedColorsBase[23],GreenColorsBase[23],BlueColorsBase[23],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[23],GreenColorsSwap[23],BlueColorsSwap[23],1.0);
	}
	ver = vec4(RedColorsBase[24],GreenColorsBase[24],BlueColorsBase[24],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[24],GreenColorsSwap[24],BlueColorsSwap[24],1.0);
	}
	ver = vec4(RedColorsBase[25],GreenColorsBase[25],BlueColorsBase[25],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[25],GreenColorsSwap[25],BlueColorsSwap[25],1.0);
	}
	ver = vec4(RedColorsBase[26],GreenColorsBase[26],BlueColorsBase[26],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[26],GreenColorsSwap[26],BlueColorsSwap[26],1.0);
	}
	ver = vec4(RedColorsBase[27],GreenColorsBase[27],BlueColorsBase[27],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[27],GreenColorsSwap[27],BlueColorsSwap[27],1.0);
	}
	ver = vec4(RedColorsBase[28],GreenColorsBase[28],BlueColorsBase[28],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[28],GreenColorsSwap[28],BlueColorsSwap[28],1.0);
	}
	ver = vec4(RedColorsBase[29],GreenColorsBase[29],BlueColorsBase[29],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[29],GreenColorsSwap[29],BlueColorsSwap[29],1.0);
	}
	ver = vec4(RedColorsBase[30],GreenColorsBase[30],BlueColorsBase[30],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[30],GreenColorsSwap[30],BlueColorsSwap[30],1.0);
	}
	ver = vec4(RedColorsBase[31],GreenColorsBase[31],BlueColorsBase[31],1.0);
	
	if(ref == ver){
		return vec4(RedColorsSwap[31],GreenColorsSwap[31],BlueColorsSwap[31],1.0);
	}
	
	return ref;
}

void main(){
    vec4 ref = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 NewColor;
	bool found = false;
	
	for(int index = 0; index < 32; index++){
		vec4 ver = vec4(RedColorsBase[index],GreenColorsBase[index],BlueColorsBase[index],1.0);
		if(ref == ver){
			NewColor = vec4(RedColorsSwap[index],GreenColorsSwap[index],BlueColorsSwap[index],1.0);
			found = true;
		}
	}
	
	if(!found){
		NewColor = ref;
	}
	
	gl_FragColor = NewColor;
}

/*void main() {
    vec4 NewColor;
    vec4 ref = texture2D(Palette, v_vTexcoord);
    const float Width = 16.0;
    int Found = 0;
    if (Offset == 0.0){
        gl_FragColor = ref;
        return;
    }
	if (Offset < 0.0){
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
		return;	
	}
	if (ref.a == 0.0){
		return;
	}
	for (float n = 0.0; n < Width; n += 1.0){
        if (Found == 1){
            break;
        }
        vec2 uv_coord = vec2((n / 16.0), (OffsetSource) / Width);
        vec4 ver = texture2D(Palette, uv_coord);
        if (ref == ver || ref == vec4(32.0/255.0,48.0/255.0,128.0/255.0, 1.0)){
            vec2 uv_coord2 = vec2((n / Width), Offset / Width);
            NewColor = texture2D(Palette, uv_coord2);
			//NewColor = vec4(128.0/255.0,48.0/255.0,128.0/255.0, 1.0);
            Found = 1;
        }
    }
    if (Found == 0){
        NewColor = ref;    
    }
    gl_FragColor = ref;
}*/