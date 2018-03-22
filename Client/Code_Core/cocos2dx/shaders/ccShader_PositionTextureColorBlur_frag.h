/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2011 Ricardo Quesada
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

"											\n\
#ifdef GL_ES								\n\
precision mediump float;					\n\
#endif										\n\
											\n\
varying vec4 v_fragmentColor;				\n\
varying vec2 v_texCoord;					\n\
uniform sampler2D CC_Texture0;				\n\
uniform vec2 CC_Blur_Size;					\n\
											\n\
void main()																												\n\
{																														\n\
	float a = (texture2D(CC_Texture0, v_texCoord)).a;  																	\n\
    vec3 color = (texture2D(CC_Texture0, v_texCoord) * v_fragmentColor).rgb;  											\n\
    float alpha = 0.0;  																								\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -1.0 * CC_Blur_Size.x, -1.0 * CC_Blur_Size.y ) ).a * 0.30; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.0                 , -1.0 * CC_Blur_Size.y ) ).a * 0.30; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  1.0 * CC_Blur_Size.x, -1.0 * CC_Blur_Size.y ) ).a * 0.30;	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -1.0 * CC_Blur_Size.x,  0.0                  ) ).a * 0.30; 	\n\
																														\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -0.5 * CC_Blur_Size.x, -0.5 * CC_Blur_Size.y ) ).a * 0.50; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.0                 , -0.5 * CC_Blur_Size.y ) ).a * 0.50; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.5 * CC_Blur_Size.x, -0.5 * CC_Blur_Size.y ) ).a * 0.50;	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -0.5 * CC_Blur_Size.x,  0.0                  ) ).a * 0.50; 	\n\
																														\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.0                 ,  0.0                  ) ).a * 0.75; 	\n\
																														\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.5 * CC_Blur_Size.x,  0.0                  ) ).a * 0.30; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -0.5 * CC_Blur_Size.x,  0.5 * CC_Blur_Size.y ) ).a * 0.30; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.0                 ,  0.5 * CC_Blur_Size.y ) ).a * 0.30;  	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.5 * CC_Blur_Size.x,  0.5 * CC_Blur_Size.y ) ).a * 0.30; 	\n\
																														\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  1.0 * CC_Blur_Size.x,  0.0                  ) ).a * 0.30; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -1.0 * CC_Blur_Size.x,  1.0 * CC_Blur_Size.y ) ).a * 0.30; 	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  0.0                 ,  1.0 * CC_Blur_Size.y ) ).a * 0.30;  	\n\
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2(  1.0 * CC_Blur_Size.x,  1.0 * CC_Blur_Size.y ) ).a * 0.30; 	\n\
  	//alpha = max(alpha,a);																								\n\
    alpha = clamp(alpha, 0.0, 1.0);  																					\n\
    gl_FragColor = vec4(color.r, color.g, color.b, alpha);																\n\
    //gl_FragColor = vec4(alpha, alpha, alpha, 1.0);																	\n\
}																														\n\
";
