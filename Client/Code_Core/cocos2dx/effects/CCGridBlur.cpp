#include "ccMacros.h"
#include "effects/CCGridBlur.h"
#include "CCDirector.h"
#include "effects/CCGrabber.h"
#include "support/ccUtils.h"
#include "shaders/CCGLProgram.h"
#include "shaders/CCShaderCache.h"
#include "shaders/ccGLStateCache.h"
#include "CCGL.h"
#include "support/CCPointExtension.h"
#include "support/TransformUtils.h"
#include "kazmath/kazmath.h"
#include "kazmath/GL/matrix.h"

#include "shaders/shaderhelper/CCBlurScreenSH.h"

NS_CC_BEGIN

// implementation of CCGrid3D

CCGridBlur* CCGridBlur::create(const CCSize& gridSize, CCTexture2D *pTexture, bool bFlipped)
{
	CCGridBlur *pRet = new CCGridBlur();

    if (pRet)
    {
        if (pRet->initWithSize(gridSize, pTexture, bFlipped))
        {
            pRet->autorelease();
        }
        else
        {
            delete pRet;
            pRet = NULL;
        }
    }

    return pRet;
}

CCGridBlur* CCGridBlur::create(const CCSize& gridSize)
{
	CCGridBlur *pRet = new CCGridBlur();

    if (pRet)
    {
        if (pRet->initWithSize(gridSize))
        {
            pRet->autorelease();
        }
        else
        {
            delete pRet;
            pRet = NULL;
        }
    }

    return pRet;
}


CCGridBlur::CCGridBlur()
    : m_pTexCoordinates(NULL)
    , m_pVertices(NULL)
    , m_pOriginalVertices(NULL)
    , m_pIndices(NULL)
{
	m_Mat = new CCBlurScreenSH( CCShaderCache::sharedShaderCache()->programForKey(kCCShader_Blur) );
}

CCGridBlur::~CCGridBlur(void)
{
	if (m_Mat)
	{
		delete m_Mat;
		m_Mat = NULL;
	}

    CC_SAFE_FREE(m_pTexCoordinates);
    CC_SAFE_FREE(m_pVertices);
    CC_SAFE_FREE(m_pIndices);
    CC_SAFE_FREE(m_pOriginalVertices);
}

CCBlurScreenSH* CCGridBlur::GetMat()
{
	return m_Mat;
}

void CCGridBlur::blit(void)
{
    int n = m_sGridSize.width * m_sGridSize.height;

    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_TexCoords );
	m_pShaderProgram = CCShaderCache::sharedShaderCache()->programForKey(kCCShader_Blur);

	m_Mat->setBlurTexture(m_pTexture);
	m_Mat->begin();

	//
	// Attributes
	//
#ifdef EMSCRIPTEN
	// Size calculations from calculateVertexPoints().
	unsigned int numOfPoints = (m_sGridSize.width+1) * (m_sGridSize.height+1);

	// position
	setGLBufferData(m_pVertices, numOfPoints * sizeof(ccVertex3F), 0);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, 0);

	// texCoords
	setGLBufferData(m_pTexCoordinates, numOfPoints * sizeof(ccVertex2F), 1);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, 0);

	setGLIndexData(m_pIndices, n * 12, 0);
	glDrawElements(GL_TRIANGLES, (GLsizei) n*6, GL_UNSIGNED_SHORT, 0);
#else
	// position
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, m_pVertices);

	// texCoords
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, m_pTexCoordinates);

	glDrawElements(GL_TRIANGLES, (GLsizei)n * 6, GL_UNSIGNED_SHORT, m_pIndices);
#endif // EMSCRIPTEN

    CC_INCREMENT_GL_DRAWS(1);
}

void CCGridBlur::calculateVertexPoints(void)
{
    float width = (float)m_pTexture->getPixelsWide();
    float height = (float)m_pTexture->getPixelsHigh();
    float imageH = m_pTexture->getContentSizeInPixels().height;

    int x, y, i;
    CC_SAFE_FREE(m_pVertices);
    CC_SAFE_FREE(m_pOriginalVertices);
    CC_SAFE_FREE(m_pTexCoordinates);
    CC_SAFE_FREE(m_pIndices);

    unsigned int numOfPoints = (m_sGridSize.width+1) * (m_sGridSize.height+1);

    m_pVertices = malloc(numOfPoints * sizeof(ccVertex3F));
    m_pOriginalVertices = malloc(numOfPoints * sizeof(ccVertex3F));
    m_pTexCoordinates = malloc(numOfPoints * sizeof(ccVertex2F));
    m_pIndices = (GLushort*)malloc(m_sGridSize.width * m_sGridSize.height * sizeof(GLushort) * 6);

    GLfloat *vertArray = (GLfloat*)m_pVertices;
    GLfloat *texArray = (GLfloat*)m_pTexCoordinates;
    GLushort *idxArray = m_pIndices;

    for (x = 0; x < m_sGridSize.width; ++x)
    {
        for (y = 0; y < m_sGridSize.height; ++y)
        {
            int idx = (y * m_sGridSize.width) + x;

            GLfloat x1 = x * m_obStep.x;
            GLfloat x2 = x1 + m_obStep.x;
            GLfloat y1 = y * m_obStep.y;
            GLfloat y2= y1 + m_obStep.y;

            GLushort a = (GLushort)(x * (m_sGridSize.height + 1) + y);
            GLushort b = (GLushort)((x + 1) * (m_sGridSize.height + 1) + y);
            GLushort c = (GLushort)((x + 1) * (m_sGridSize.height + 1) + (y + 1));
            GLushort d = (GLushort)(x * (m_sGridSize.height + 1) + (y + 1));

            GLushort tempidx[6] = {a, b, d, b, c, d};

            memcpy(&idxArray[6*idx], tempidx, 6*sizeof(GLushort));

            int l1[4] = {a*3, b*3, c*3, d*3};
            ccVertex3F e = {x1, y1, 0};
            ccVertex3F f = {x2, y1, 0};
            ccVertex3F g = {x2, y2, 0};
            ccVertex3F h = {x1, y2, 0};

            ccVertex3F l2[4] = {e, f, g, h};

            int tex1[4] = {a*2, b*2, c*2, d*2};
            CCPoint tex2[4] = {ccp(x1, y1), ccp(x2, y1), ccp(x2, y2), ccp(x1, y2)};

            for (i = 0; i < 4; ++i)
            {
                vertArray[l1[i]] = l2[i].x;
                vertArray[l1[i] + 1] = l2[i].y;
                vertArray[l1[i] + 2] = l2[i].z;

                texArray[tex1[i]] = tex2[i].x / width;
                if (m_bIsTextureFlipped)
                {
                    texArray[tex1[i] + 1] = (imageH - tex2[i].y) / height;
                }
                else
                {
                    texArray[tex1[i] + 1] = tex2[i].y / height;
                }
            }
        }
    }

    memcpy(m_pOriginalVertices, m_pVertices, (m_sGridSize.width+1) * (m_sGridSize.height+1) * sizeof(ccVertex3F));

	if (m_Mat)
	{
		m_Mat->init();
	}
}

ccVertex3F CCGridBlur::vertex(const CCPoint& pos)
{
    CCAssert( pos.x == (unsigned int)pos.x && pos.y == (unsigned int) pos.y , "Numbers must be integers");
    
    int index = (pos.x * (m_sGridSize.height+1) + pos.y) * 3;
    float *vertArray = (float*)m_pVertices;

    ccVertex3F vert = {vertArray[index], vertArray[index+1], vertArray[index+2]};

    return vert;
}

ccVertex3F CCGridBlur::originalVertex(const CCPoint& pos)
{
    CCAssert( pos.x == (unsigned int)pos.x && pos.y == (unsigned int) pos.y , "Numbers must be integers");
    
    int index = (pos.x * (m_sGridSize.height+1) + pos.y) * 3;
    float *vertArray = (float*)m_pOriginalVertices;

    ccVertex3F vert = {vertArray[index], vertArray[index+1], vertArray[index+2]};

    return vert;
}

void CCGridBlur::setVertex(const CCPoint& pos, const ccVertex3F& vertex)
{
    CCAssert( pos.x == (unsigned int)pos.x && pos.y == (unsigned int) pos.y , "Numbers must be integers");
    int index = (pos.x * (m_sGridSize.height + 1) + pos.y) * 3;
    float *vertArray = (float*)m_pVertices;
    vertArray[index] = vertex.x;
    vertArray[index+1] = vertex.y;
    vertArray[index+2] = vertex.z;
}

void CCGridBlur::reuse(void)
{
    if (m_nReuseGrid > 0)
    {
        memcpy(m_pOriginalVertices, m_pVertices, (m_sGridSize.width+1) * (m_sGridSize.height+1) * sizeof(ccVertex3F));
        --m_nReuseGrid;
    }
}

NS_CC_END
