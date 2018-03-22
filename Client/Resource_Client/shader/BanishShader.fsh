#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
	gl_FragColor = texture2D(u_texture, v_texCoord) * v_fragmentColor;
	float gg = (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) * (1.0 / 3.0);
    gl_FragColor = vec4(gg * 0.9, gg * 1.2, gg * 0.8, gl_FragColor.a * (gg + 0.1));
}

