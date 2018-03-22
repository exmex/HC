#include "CCBlurScreenSH.h"
#include "../CCGLProgram.h"
#include "../../textures/CCTexture2D.h"

NS_CC_BEGIN


CCBlurScreenSH::CCBlurScreenSH(CCGLProgram* _program)
: CCShaderHelper(_program)
{
	uni_blursize = 0;
	uni_substract = 0;
	s_Tex0 = 0;

	substract_x = 0.0;
	substract_y = 0.0;
	substract_z = 0.0;
	substract_w = 0.0;

	blursize_x = 1;
	blursize_y = 1;

	m_BlurTex = NULL;

	init();
}

CCBlurScreenSH::~CCBlurScreenSH()
{
}

void CCBlurScreenSH::init()
{
	uni_blursize = glGetUniformLocation(m_Program->getProgram(), "v_blurSize");
	uni_substract = glGetUniformLocation(m_Program->getProgram(), "v_substract");
	s_Tex0 = glGetUniformLocation(m_Program->getProgram(), "s_TexBlur");
}

void CCBlurScreenSH::begin()
{
	CCShaderHelper::begin();

	if (m_Program)
	{
		m_Program->use();
		m_Program->updateUniforms();
		m_Program->setUniformsForBuiltins();

		//glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, 128, 128, 0);
		if (s_Tex0>0 && m_BlurTex)
		{
			glBindTexture(GL_TEXTURE_2D, m_BlurTex->getName());
			glUniform1i(s_Tex0, 0);
		}

		if (uni_blursize > 0 && m_BlurTex)
			m_Program->setUniformLocationWith2f(uni_blursize, blursize_x / m_BlurTex->getPixelsWide(), blursize_y / m_BlurTex->getPixelsWide());
		if (uni_substract > 0)
			m_Program->setUniformLocationWith4f(uni_substract, substract_x, substract_y, substract_z, substract_w);
	}
}

void CCBlurScreenSH::end()
{
	CCShaderHelper::end();
}

void CCBlurScreenSH::setSubStract(float _x, float _y, float _z, float _w)
{
	substract_x = _x;
	substract_y = _y;
	substract_z = _z;
	substract_w = _w;
}

void CCBlurScreenSH::setBlursize(float _blur_x, float _blur_y)
{
	blursize_x = _blur_x ;
	blursize_y = _blur_y ;
}

void CCBlurScreenSH::setBlurTexture(CCTexture2D* _tex)
{
	if (m_BlurTex != _tex)
	{
		m_BlurTex = _tex;
	}
}

NS_CC_END
