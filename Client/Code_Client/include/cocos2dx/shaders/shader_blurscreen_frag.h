"												\n\
#ifdef GL_ES									\n\
precision lowp float;							\n\
#endif											\n\
												\n\
varying vec2 v_texCoord;						\n\
uniform sampler2D s_TexBlur;					\n\
uniform vec2 v_blurSize;						\n\
uniform vec4 v_substract;						\n\
												\n\
void main()										\n\
{												\n\
	vec4 sum = vec4(0.0);													\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( v_blurSize.x , v_blurSize.y) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( -v_blurSize.x , v_blurSize.y) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( v_blurSize.x , -v_blurSize.y) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( -v_blurSize.x , -v_blurSize.y) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord                 ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( v_blurSize.x , 0) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( -v_blurSize.x , 0) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( 0 , v_blurSize.y) ) * 0.111;	\n\
	sum += texture2D(s_TexBlur, v_texCoord + vec2( 0 , -v_blurSize.y) ) * 0.111;	\n\
	gl_FragColor = (sum - v_substract);					\n\
}												\n\
";
