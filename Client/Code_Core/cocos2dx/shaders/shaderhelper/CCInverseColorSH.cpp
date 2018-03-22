#include "CCInverseColorSH.h"
#include "../CCGLProgram.h"
#include "../../textures/CCTexture2D.h"

NS_CC_BEGIN


CCInverseColorSH::CCInverseColorSH(CCGLProgram* _program)
: CCShaderHelper(_program)
{
	
	m_InverseTex= NULL;

	init();
}

CCInverseColorSH::~CCInverseColorSH()
{
	CC_SAFE_RELEASE(m_InverseTex);
}

void CCInverseColorSH::init()
{
	s_Tex0 = glGetUniformLocation(m_Program->getProgram(), "s_TexInverse");
}

void CCInverseColorSH::begin()
{
	CCShaderHelper::begin();

	if (m_Program)
	{
		m_Program->use();
		m_Program->updateUniforms();
		m_Program->setUniformsForBuiltins();

		//glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, 128, 128, 0);
		if (s_Tex0>0 && m_InverseTex)
		{
			glBindTexture(GL_TEXTURE_2D, m_InverseTex->getName());
			glUniform1i(s_Tex0, 0);
		}
	}
}

void CCInverseColorSH::end()
{
	CCShaderHelper::end();
}

void CCInverseColorSH::setInverseTexture(CCTexture2D* _tex)
{
	if (m_InverseTex != _tex)
	{
		CC_SAFE_RETAIN(_tex); 
		CC_SAFE_RELEASE(m_InverseTex); 
		m_InverseTex = _tex;
	}
}

NS_CC_END
