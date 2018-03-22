#include "CCTextFadeSH.h"
#include "../CCGLProgram.h"
#include "../../textures/CCTexture2D.h"

NS_CC_BEGIN


CCTextFadeSH::CCTextFadeSH(CCGLProgram* _program)
: CCShaderHelper(_program)
{
	m_SrcTex = NULL;
	m_FadeTex = NULL;

	s_src_tex = 0;
	s_fade_tex = 0;

	init();
}

CCTextFadeSH::~CCTextFadeSH()
{
}

void CCTextFadeSH::init()
{
	s_src_tex = glGetUniformLocation(m_Program->getProgram(), "s_Texture0");
	s_fade_tex = glGetUniformLocation(m_Program->getProgram(), "s_Texture1");
}

void CCTextFadeSH::begin()
{
	CCShaderHelper::begin();

	if (m_Program)
	{
		if (m_SrcTex && (s_src_tex>0))
		{
			glActiveTexture(GL_TEXTURE0);
			glBindTexture(GL_TEXTURE_2D, m_SrcTex->getName());
			glUniform1i(s_src_tex, 0);
		}
		if (m_FadeTex && (s_fade_tex>0))
		{
			glActiveTexture(GL_TEXTURE1);
			glBindTexture(GL_TEXTURE_2D, m_FadeTex->getName());
			glUniform1i(s_fade_tex, 1);
		}
	}
}

void CCTextFadeSH::end()
{
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, 0);

	glActiveTexture(GL_TEXTURE1);
	glBindTexture(GL_TEXTURE_2D, 0);

	//
	if (m_SrcTex)
		m_SrcTex->release();
	m_SrcTex = NULL;

	if (m_FadeTex)
		m_FadeTex->release();
	m_FadeTex = NULL;

	CCShaderHelper::end();
}

void CCTextFadeSH::setSrcTexture(CCTexture2D* _tex)
{
	if (_tex)
	{
		_tex->retain();
		if (m_SrcTex)
			m_SrcTex->release();
	}
	m_SrcTex = _tex;
}

void CCTextFadeSH::setFadeTexture(CCTexture2D* _tex)
{
	if (_tex)
	{
		_tex->retain();
		if (m_FadeTex)
			m_FadeTex->release();
	}
	m_FadeTex = _tex;
}

NS_CC_END
