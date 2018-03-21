#ifndef __EFFECTS_CCGRID_BLUR_H__
#define __EFFECTS_CCGRID_BLUR_H__

#include "cocoa/CCObject.h"
#include "base_nodes/CCNode.h"
#include "CCCamera.h"
#include "ccTypes.h"
#include "textures/CCTexture2D.h"
#include "CCDirector.h"
#include "kazmath/mat4.h"
#include "CCGrid.h"
#ifdef EMSCRIPTEN
#include "base_nodes/CCGLBufferedNode.h"
#endif // EMSCRIPTEN

NS_CC_BEGIN

class CCTexture2D;
class CCGrabber;
class CCGLProgram;
class CDataChunk;
class CVBO;
class CCBlurScreenSH;

class CC_DLL CCGridBlur : public CCGridBase
#ifdef EMSCRIPTEN
, public CCGLBufferedNode
#endif // EMSCRIPTEN
{
public:
	CCGridBlur();
	~CCGridBlur(void);

    /** returns the vertex at a given position */
    ccVertex3F vertex(const CCPoint& pos);
    /** returns the original (non-transformed) vertex at a given position */
    ccVertex3F originalVertex(const CCPoint& pos);
    /** sets a new vertex at a given position */
    void setVertex(const CCPoint& pos, const ccVertex3F& vertex);

    virtual void blit(void);
    virtual void reuse(void);
    virtual void calculateVertexPoints(void);

	CCBlurScreenSH* GetMat();

public:
    /** create one Grid */
	static CCGridBlur* create(const CCSize& gridSize, CCTexture2D *pTexture, bool bFlipped);
    /** create one Grid */
	static CCGridBlur* create(const CCSize& gridSize);
    
protected:
    GLvoid *m_pTexCoordinates;
    GLvoid *m_pVertices;
    GLvoid *m_pOriginalVertices;
    GLushort *m_pIndices;

	bool m_flag;
	CCBlurScreenSH* m_Mat;
};

NS_CC_END

#endif // __EFFECTS_CCGRID_BLUR_H__
