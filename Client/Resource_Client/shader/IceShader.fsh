#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 clrx = texture2D(u_texture, v_texCoord) * v_fragmentColor;
	float brightness = (clrx.r + clrx.g + clrx.b) * (1. / 3.);
	float gray = (1.5)*brightness;
	clrx = vec4(gray, gray, gray, clrx.a)*vec4(0.8,1.2,1.5,1);
    gl_FragColor =clrx;
}
