#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 clrNormal = v_fragmentColor * texture2D(u_texture, v_texCoord);
    clrNormal.r = clrNormal.r * 0.5;
    clrNormal.g = clrNormal.g * 0.8;
    clrNormal.b = clrNormal.b + clrNormal.a * 0.2;
    gl_FragColor = clrNormal;
}

