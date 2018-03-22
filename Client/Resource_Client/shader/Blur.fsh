#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;

uniform vec2 blurSize;

void main() {
	vec4 sum = vec4(0.0);
	vec4 substract = vec4(0,0,0,0);

	float alpha = texture2D(CC_Texture0 , v_texCoord).a;

	sum += texture2D(CC_Texture0, v_texCoord - 4.0 * blurSize) * 0.05;
	sum += texture2D(CC_Texture0, v_texCoord - 3.0 * blurSize) * 0.09;
	sum += texture2D(CC_Texture0, v_texCoord - 2.0 * blurSize) * 0.12;
	sum += texture2D(CC_Texture0, v_texCoord - 1.0 * blurSize) * 0.15;
	sum += texture2D(CC_Texture0, v_texCoord                 ) * 0.16;
	sum += texture2D(CC_Texture0, v_texCoord + 1.0 * blurSize) * 0.15;
	sum += texture2D(CC_Texture0, v_texCoord + 2.0 * blurSize) * 0.12;
	sum += texture2D(CC_Texture0, v_texCoord + 3.0 * blurSize) * 0.09;
	sum += texture2D(CC_Texture0, v_texCoord + 4.0 * blurSize) * 0.05;

	vec4 vectemp = vec4(0,0,0,0);
	vectemp = (sum - substract) * v_fragmentColor;

	if(alpha < 0.05)
	{
		gl_FragColor = vec4(0 , 0 , 0 , 0);
	}
	else
	{
		gl_FragColor = vectemp;
	}
}

