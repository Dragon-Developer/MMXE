// this palette system is a concept where you pass 2 textures; a reference palette and the applied
// palette. this makes it so any palette could be applied to any sprite, with the obvious problems
// that come from such a method. it mostly exists for the purposes of sharing weapon palettes easily
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//  Get palette as texture
uniform sampler2D PaletteBase;
uniform sampler2D PaletteNew;

// texture width
uniform float width;

void main() {
    vec4 NewColor;
    vec4 ref = texture2D(gm_BaseTexture, v_vTexcoord);
    bool Found = false;
	//if the texture pixel we are dealing with is invisible, keep it invisible
	if (ref.a == 0.0){
		return;
	}
	//check each color on the texture and replace it accordingly
	for (float n = 0.0; n < width; n += 1.0){
		//if we already have the texture, then get out of the loop
        if (Found){
            break;
        }
		//get the color that we are messing with
        vec2 uv_coord = vec2((n / width), 0);
        vec4 ver = texture2D(PaletteBase, uv_coord);
		//if the current pixel is the same color as the palette color we are comparing with
        if (ref == ver){
			//get the color from the palette
            vec2 uv_coord2 = vec2((n / width), 0);
            NewColor = texture2D(PaletteNew, uv_coord2);
			//and break
            Found = true;
        }
    }
	//if we went through the loop and nothing was found, just return the original color
    if (!Found){
        NewColor = ref;    
    }
	//pass newcolor, which we modified earlier depending on the outcome
    gl_FragColor = NewColor;
}