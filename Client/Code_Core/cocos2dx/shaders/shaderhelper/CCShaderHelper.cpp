#include "CCShaderHelper.h"
#include "../CCGLProgram.h"


NS_CC_BEGIN


CCShaderHelper::CCShaderHelper(CCGLProgram* _program)
: m_Program(_program)
{
	if (m_Program)
		m_Program->retain();
}

CCShaderHelper::~CCShaderHelper()
{
	if (m_Program)
	{
		m_Program->release();
	}
}

void CCShaderHelper::init()
{
}

void CCShaderHelper::begin()
{
	if (m_Program)
	{
		m_Program->use();
		m_Program->setUniformsForBuiltins();
	}
}

void CCShaderHelper::end()
{
	if (m_Program)
	{
		m_Program->release();
		m_Program = NULL;
	}
}

NS_CC_END
