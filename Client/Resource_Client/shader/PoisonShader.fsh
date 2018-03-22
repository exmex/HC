#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    //todo
    
    gl_FragColor = texture2D(u_texture, v_texCoord) * v_fragmentColor;
	gl_FragColor.r *= 0.8;
    //todo
	gl_FragColor.r += 0.08 * gl_FragColor.a;
	gl_FragColor.g *= 0.8;
	gl_FragColor.b *= 0.8;
	gl_FragColor.g += 0.2 * gl_FragColor.a;
}
