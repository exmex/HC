#ifndef __CCDDSTEXTURE_H__
#define __CCDDSTEXTURE_H__

#include "cocoa/CCObject.h"
#include "CCStdC.h"
#include "CCGL.h"
#include "cocoa/CCArray.h"
#include "CCTexture2D.h"

NS_CC_BEGIN
/**
 *  @js NA
 *  @lua NA
 */
class CC_DLL CCTextureDDS : public CCObject
{
public:
	CCTextureDDS();
	virtual ~CCTextureDDS();

    bool initWithFile(const char* file);

    unsigned int getName() const;
    unsigned int getWidth() const;
    unsigned int getHeight() const;
	unsigned int getMipMap() const;
	CCTexture2DPixelFormat getFormate();
    
private:
    bool loadTexture(const char* file);

private:
    GLuint					_name;
    unsigned int			_width;
    unsigned int			_height;
	CCTexture2DPixelFormat m_eFormat;
	unsigned int			_mipmap;
};

NS_CC_END

#endif /* defined(__CCDDSTEXTURE_H__) */
