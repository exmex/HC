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
precision lowp float;						\n\
#endif										\n\
											\n\
varying vec4 v_fragmentColor;				\n\
varying vec2 v_texCoord;					\n\
uniform sampler2D CC_Texture0;				\n\
uniform vec4 v_BorderColor;					\n\
uniform vec2 v_BorderWidth;					\n\
											\n\
void main()									\n\
{											\n\
	float offx = v_BorderWidth.x;					\n\
	float offy = v_BorderWidth.y;					\n\
	vec4 tex  = texture2D(CC_Texture0, v_texCoord );			\n\
	vec4 tex0 = texture2D(CC_Texture0, v_texCoord + vec2(offx , 0.0));			\n\
	vec4 tex1 = texture2D(CC_Texture0, v_texCoord + vec2(-offx , 0.0));			\n\
	vec4 tex2 = texture2D(CC_Texture0, v_texCoord + vec2(0.0 , offy));			\n\
	vec4 tex3 = texture2D(CC_Texture0, v_texCoord + vec2(0.0 , -offy));			\n\
	vec4 tex4 = texture2D(CC_Texture0, v_texCoord + vec2(offx , offy));			\n\
	vec4 tex5 = texture2D(CC_Texture0, v_texCoord + vec2(offx , -offy));			\n\
	vec4 tex6 = texture2D(CC_Texture0, v_texCoord + vec2(-offx , -offy));			\n\
	vec4 tex7 = texture2D(CC_Texture0, v_texCoord + vec2(-offx , offy));			\n\
	vec4 tex_avg = (tex + tex0 + tex1 + tex2 + tex3 + tex4 + tex5 + tex6 + tex7)/9.0;			\n\
	if(tex_avg.a<= (8.0/9.0) && tex_avg.a>0.0)															\n\
		gl_FragColor = v_BorderColor;											\n\
	else																		\n\
		gl_FragColor = v_fragmentColor * tex;									\n\
}																				\n\
";
