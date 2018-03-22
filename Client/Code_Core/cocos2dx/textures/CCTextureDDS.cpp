#include "CCTextureDDS.h"
#include "platform/CCPlatformConfig.h"
#include "platform/CCFileUtils.h"
#include "DDSLoader.h"

NS_CC_BEGIN

CCTextureDDS::CCTextureDDS()
: _name(0)
, _width(0)
, _height(0)
{}

CCTextureDDS::~CCTextureDDS()
{
}

bool CCTextureDDS::initWithFile(const char *file)
{
    // Only Android supports ETC file format
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8)
	tScratchImage tmpImage;
	bool ret = LoadDDS(file, tmpImage);

	_width = tmpImage.GetMetadata().width;
	_height = tmpImage.GetMetadata().height;


	glGenTextures(1, &_name);
	glBindTexture(GL_TEXTURE_2D, _name);

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

	int tFormate = 0;
	switch (tmpImage.GetMetadata().format)
	{
	case tDXGI_FORMAT_BC1_UNORM:
	case tDXGI_FORMAT_BC1_UNORM_SRGB:
	case tDXGI_FORMAT_BC1_TYPELESS:
	{
		tFormate = GL_COMPRESSED_RGBA_S3TC_DXT1_EXT; 
		m_eFormat = kCCTexture2DPixelFormat_DXT1;
		break;
	}
	case tDXGI_FORMAT_BC3_UNORM:
	case tDXGI_FORMAT_BC3_UNORM_SRGB:
	case tDXGI_FORMAT_BC3_TYPELESS:
	{
		tFormate = GL_COMPRESSED_RGBA_S3TC_DXT3_ANGLE;
		m_eFormat = kCCTexture2DPixelFormat_DXT3;
		break;
	}
	case tDXGI_FORMAT_BC5_UNORM:
	case tDXGI_FORMAT_BC5_SNORM:
	case tDXGI_FORMAT_BC5_TYPELESS:
	{
		tFormate = GL_COMPRESSED_RGBA_S3TC_DXT5_ANGLE;
		m_eFormat = kCCTexture2DPixelFormat_DXT5;
		break;
	}
	default:
		break;
	}

	_mipmap = tmpImage.GetMetadata().mipLevels;
	

	for (int i = 0; i < _mipmap; i++)
	{
		const tImage* innerImage = tmpImage.GetImage(i,0,0);
		if (innerImage)
		{
			glCompressedTexImage2D(GL_TEXTURE_2D, i, tFormate, innerImage->width, innerImage->height, 0, innerImage->slicePitch, innerImage->pixels);
		}
	}

	glBindTexture(GL_TEXTURE_2D, 0);

	GLenum err = glGetError();
	if (err != GL_NO_ERROR)
	{
		return false;
	}

    return ret;
#else
    return false;
#endif
}

unsigned int CCTextureDDS::getName() const
{
    return _name;
}

unsigned int CCTextureDDS::getWidth() const
{
    return _width;
}

unsigned int CCTextureDDS::getHeight() const
{
    return _height;
}

unsigned int CCTextureDDS::getMipMap() const
{
	return _mipmap;
}

CCTexture2DPixelFormat CCTextureDDS::getFormate()
{
	return m_eFormat;
}

bool CCTextureDDS::loadTexture(const char* file)
{
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8)
//       
//    glGenTextures(1, &_name);
//    glBindTexture(GL_TEXTURE_2D, _name);      
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//	
//	//glLoadCompressTexture(NULL);
//	//glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_S3TC_DXT3_ANGLE, _width, _height, 0, 0, NULL);
//    
//	glBindTexture(GL_TEXTURE_2D, 0); 
//    GLenum err = glGetError();
//    if (err != GL_NO_ERROR)
//    {
//        return false;
//    }
//#else
//    return false;
//#endif
	return true;
}

NS_CC_END
