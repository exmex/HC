/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#import "CCImage.h"
#import "CCFileUtils.h"
#import "CCCommon.h"
#import <string>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include<math.h>


typedef struct
{
    unsigned int height;
    unsigned int width;
    int          bitsPerComponent;
    bool         hasAlpha;
    bool         isPremultipliedAlpha;
    bool         hasShadow;
    CGSize       shadowOffset;
    float        shadowBlur;
    float        shadowOpacity;
    bool         hasStroke;
    float        strokeColorR;
    float        strokeColorG;
    float        strokeColorB;
    float        strokeSize;
    float        tintColorR;
    float        tintColorG;
    float        tintColorB;
    
    float        shadowColorR;
    float        shadowColorG;
    float        shadowColorB;
    
    unsigned char*  data;
    
} tImageInfo;

static bool _initWithImage(CGImageRef cgImage, tImageInfo *pImageinfo)
{
    if(cgImage == NULL)
    {
        return false;
    }
    
    // get image info
    
    pImageinfo->width = CGImageGetWidth(cgImage);
    pImageinfo->height = CGImageGetHeight(cgImage);
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(cgImage);
    pImageinfo->hasAlpha = (info == kCGImageAlphaPremultipliedLast)
    || (info == kCGImageAlphaPremultipliedFirst)
    || (info == kCGImageAlphaLast)
    || (info == kCGImageAlphaFirst);
    
    // If OS version < 5.x, add condition to support jpg
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(systemVersion < 5.0f)
    {
        pImageinfo->hasAlpha = (pImageinfo->hasAlpha || (info == kCGImageAlphaNoneSkipLast));
    }
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    if (colorSpace)
    {
        if (pImageinfo->hasAlpha)
        {
            info = kCGImageAlphaPremultipliedLast;
            pImageinfo->isPremultipliedAlpha = true;
        }
        else
        {
            info = kCGImageAlphaNoneSkipLast;
            pImageinfo->isPremultipliedAlpha = false;
        }
    }
    else
    {
        return false;
    }
    
    // change to RGBA8888
    pImageinfo->hasAlpha = true;
    pImageinfo->bitsPerComponent = 8;
    pImageinfo->data = new unsigned char[pImageinfo->width * pImageinfo->height * 4];
    colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pImageinfo->data,
                                                 pImageinfo->width,
                                                 pImageinfo->height,
                                                 8,
                                                 4 * pImageinfo->width,
                                                 colorSpace,
                                                 info | kCGBitmapByteOrder32Big);
    
    CGContextClearRect(context, CGRectMake(0, 0, pImageinfo->width, pImageinfo->height));
    //CGContextTranslateCTM(context, 0, 0);
    CGContextDrawImage(context, CGRectMake(0, 0, pImageinfo->width, pImageinfo->height), cgImage);
    
    CGContextRelease(context);
    CFRelease(colorSpace);
    
    return true;
}

static bool _initWithFile(const char* path, tImageInfo *pImageinfo)
{
    CGImageRef                CGImage;
    UIImage                    *jpg;
    UIImage                    *png;
    bool            ret;
    
    // convert jpg to png before loading the texture
    
    NSString *fullPath = [NSString stringWithUTF8String:path];
    jpg = [[UIImage alloc] initWithContentsOfFile: fullPath];
    png = [[UIImage alloc] initWithData:UIImagePNGRepresentation(jpg)];
    CGImage = png.CGImage;
    
    ret = _initWithImage(CGImage, pImageinfo);
    
    [png release];
    [jpg release];
    
    return ret;
}


static bool _initWithData(void * pBuffer, int length, tImageInfo *pImageinfo)
{
    bool ret = false;
    
    if (pBuffer)
    {
        CGImageRef CGImage;
        NSData *data;
        
        data = [NSData dataWithBytes:pBuffer length:length];
        CGImage = [[UIImage imageWithData:data] CGImage];
        
        ret = _initWithImage(CGImage, pImageinfo);
    }
    
    return ret;
}

static CGSize _calculateStringSize(NSString *str, id font, CGSize *constrainSize)
{
    NSArray *listItems = [str componentsSeparatedByString: @"\n"];
    CGSize dim = CGSizeZero;
    CGSize textRect = CGSizeZero;
    textRect.width = constrainSize->width > 0 ? constrainSize->width
    : 0x7fffffff;
    textRect.height = constrainSize->height > 0 ? constrainSize->height
    : 0x7fffffff;
    
    
    for (NSString *s in listItems)
    {
        CGSize tmp = [s sizeWithFont:font constrainedToSize:textRect];
        
        if (tmp.width > dim.width)
        {
            dim.width = tmp.width;
        }
        
        dim.height += tmp.height;
    }
    
    return dim;
}

// refer CCImage::ETextAlign
#define ALIGN_TOP    1
#define ALIGN_CENTER 3
#define ALIGN_BOTTOM 2

static bool _initWithString(const char * pText, cocos2d::CCImage::ETextAlign eAlign, const char * pFontName, int nSize, tImageInfo* pInfo)
{
    bool bRet = false;
    do
    {
        CC_BREAK_IF(! pText || ! pInfo);
        
        NSString * str          = [NSString stringWithUTF8String:pText];
        NSString * fntName      = [NSString stringWithUTF8String:pFontName];
        
        CGSize dim, constrainSize;
        
        constrainSize.width     = pInfo->width;
        constrainSize.height    = pInfo->height;
        
        // On iOS custom fonts must be listed beforehand in the App info.plist (in order to be usable) and referenced only the by the font family name itself when
        // calling [UIFont fontWithName]. Therefore even if the developer adds 'SomeFont.ttf' or 'fonts/SomeFont.ttf' to the App .plist, the font must
        // be referenced as 'SomeFont' when calling [UIFont fontWithName]. Hence we strip out the folder path components and the extension here in order to get just
        // the font family name itself. This stripping step is required especially for references to user fonts stored in CCB files; CCB files appear to store
        // the '.ttf' extensions when referring to custom fonts.
        fntName = [[fntName lastPathComponent] stringByDeletingPathExtension];
        
        // create the font
        id font = [UIFont fontWithName:fntName size:nSize];
        
        if (font)
        {
            dim = _calculateStringSize(str, font, &constrainSize);
        }
        else
        {
            if (!font)
            {
                font = [UIFont systemFontOfSize:nSize];
            }
            
            if (font)
            {
                dim = _calculateStringSize(str, font, &constrainSize);
            }
        }
        
        CC_BREAK_IF(! font);
        
        // compute start point
        int startH = 0;
        if (constrainSize.height > dim.height)
        {
            // vertical alignment
            unsigned int vAlignment = (eAlign >> 4) & 0x0F;
            if (vAlignment == ALIGN_TOP)
            {
                startH = 0;
            }
            else if (vAlignment == ALIGN_CENTER)
            {
                startH = (constrainSize.height - dim.height) / 2;
            }
            else
            {
                startH = constrainSize.height - dim.height;
            }
        }
        
        // adjust text rect
        if (constrainSize.width > 0 && constrainSize.width > dim.width)
        {
            dim.width = constrainSize.width;
        }
        if (constrainSize.height > 0 && constrainSize.height > dim.height)
        {
            dim.height = constrainSize.height;
        }
        
        
        // compute the padding needed by shadow and stroke
        float shadowStrokePaddingX = 0.0f;
        float shadowStrokePaddingY = 0.0f;
        
        if ( pInfo->hasStroke )
        {
            shadowStrokePaddingX = ceilf(pInfo->strokeSize);
            shadowStrokePaddingY = ceilf(pInfo->strokeSize);
        }
        
        if ( pInfo->hasShadow )
        {
            shadowStrokePaddingX = ceilf(std::max(shadowStrokePaddingX, fabsf(pInfo->shadowOffset.width)));
            shadowStrokePaddingY = ceilf(std::max(shadowStrokePaddingY, fabsf(pInfo->shadowOffset.height)));
        }
        
        // add the padding (this could be 0 if no shadow and no stroke)
        dim.width  += shadowStrokePaddingX;
        dim.height += shadowStrokePaddingY + 1;
        
        
        unsigned char* data = new unsigned char[(int)(dim.width * dim.height * 4)];
        memset(data, 0, (int)(dim.width * dim.height * 4));
        
        // draw text
        CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
        CGContextRef context        = CGBitmapContextCreate(data,
                                                            dim.width,
                                                            dim.height,
                                                            8,
                                                            (int)(dim.width) * 4,
                                                            colorSpace,
                                                            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        
//        CGColorRef sclr  = CGColorCreate(colorSpace,
//                                         [pInfo->shadowColorR,pInfo->shadowColorG,pInfo->shadowColorB,1.0]);
        
        CGColorSpaceRelease(colorSpace);
        
        if (!context)
        {
            delete[] data;
            break;
        }
        
        // text color
        CGContextSetRGBFillColor(context, pInfo->tintColorR, pInfo->tintColorG, pInfo->tintColorB, 1);
        // move Y rendering to the top of the image
        CGContextTranslateCTM(context, 0.0f, dim.height);
        CGContextScaleCTM(context, 1.0f, -1.0f); //NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
        
        // store the current context
        UIGraphicsPushContext(context);
        
        // measure text size with specified font and determine the rectangle to draw text in
        unsigned uHoriFlag = eAlign & 0x0f;
        UITextAlignment align = (UITextAlignment)((2 == uHoriFlag) ? UITextAlignmentRight
                                                  : (3 == uHoriFlag) ? UITextAlignmentCenter
                                                  : UITextAlignmentLeft);
        
        
        // take care of shadow if needed
        if ( pInfo->hasShadow )
        {
            CGSize offset;
            offset.height = pInfo->shadowOffset.height;
            offset.width  = pInfo->shadowOffset.width;
       
            CGContextSetShadowWithColor(context, offset, pInfo->shadowBlur,
                                        [UIColor colorWithRed:pInfo->shadowColorR green:pInfo->shadowColorG blue:pInfo->shadowColorB alpha:1.0f].CGColor);
        }
        
        
        
        
        
        // normal fonts
        //if( [font isKindOfClass:[UIFont class] ] )
        //{
        //    [str drawInRect:CGRectMake(0, startH, dim.width, dim.height) withFont:font lineBreakMode:(UILineBreakMode)UILineBreakModeWordWrap alignment:align];
        //}
        //else // ZFont class
        //{
        //    [FontLabelStringDrawingHelper drawInRect:str rect:CGRectMake(0, startH, dim.width, dim.height) withZFont:font lineBreakMode:(UILineBreakMode)UILineBreakModeWordWrap
        ////alignment:align];
        //}
        
        
        
        // compute the rect used for rendering the text
        // based on wether shadows or stroke are enabled
        
        float textOriginX  = 0.0;
        float textOrigingY = 0.0;
        
        float textWidth    = dim.width  - shadowStrokePaddingX;
        float textHeight   = dim.height - shadowStrokePaddingY;
        
        if ( pInfo->shadowOffset.width < 0 )
        {
            textOriginX = shadowStrokePaddingX;
        }
        else
        {
            textOriginX = shadowStrokePaddingX/2;
        }
        
        if (pInfo->shadowOffset.height > 0)
        {
            textOrigingY = startH;
        }
        else
        {
            textOrigingY = startH;// - shadowStrokePaddingY / 2;
        }
        
        
        // take care of stroke if needed
        if ( pInfo->hasStroke )
        {
            CGContextSetTextDrawingMode(context, kCGTextStroke);
            CGContextSetRGBFillColor(context, pInfo->strokeColorR, pInfo->strokeColorG, pInfo->strokeColorB, 1);
            CGContextSetLineWidth(context, pInfo->strokeSize);
            // actually draw the text in the context
            // XXX: ios7 casting
            [str drawInRect:CGRectMake(0, 0, dim.width, dim.height) withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:(NSTextAlignment)align];
            
            CGContextSetTextDrawingMode(context, kCGTextFill);
            CGContextSetRGBFillColor(context, pInfo->tintColorR, pInfo->tintColorG, pInfo->tintColorB, 1);
        }
        
        // actually draw the text in the context
		// XXX: ios7 casting
        [str drawInRect:CGRectMake(textOriginX, textOrigingY, textWidth, textHeight) withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:(NSTextAlignment)align];
        
        // pop the context
        UIGraphicsPopContext();
        
        // release the context
        CGContextRelease(context);
        
        // output params
        pInfo->data                 = data;
        pInfo->hasAlpha             = true;
        pInfo->isPremultipliedAlpha = true;
        pInfo->bitsPerComponent     = 8;
        pInfo->width                = dim.width;
        pInfo->height               = dim.height;
        bRet                        = true;
        
    } while (0);
    
    return bRet;
}

NS_CC_BEGIN
bool CCImage::img_PaletteEnable(false);

void CCImage::setImgPaletteEnable(bool bEnable){
    img_PaletteEnable = bEnable;

}

CCImage::CCImage()
: m_nWidth(0)
, m_nHeight(0)
, m_nBitsPerComponent(0)
, m_pData(0)
, m_bHasAlpha(false)
, m_bPreMulti(false)
{
    
}

CCImage::~CCImage()
{
    CC_SAFE_DELETE_ARRAY(m_pData);
}

bool CCImage::initWithImageFile(const char * strPath, EImageFormat eImgFmt/* = eFmtPng*/)
{
	bool bRet = false;
    unsigned long nSize = 0;
    unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(
                                                                         CCFileUtils::sharedFileUtils()->fullPathForFilename(strPath).c_str(),
                                                                         "rb",
                                                                         &nSize);
    
    if (pBuffer != NULL && nSize > 0)
    {
        bRet = initWithImageData(pBuffer, nSize, eImgFmt);
    }
    CC_SAFE_DELETE_ARRAY(pBuffer);
    return bRet;
}

bool CCImage::initWithImageFileThreadSafe(const char *fullpath, EImageFormat imageType)
{
    /*
     * CCFileUtils::fullPathFromRelativePath() is not thread-safe, it use autorelease().
     */
    bool bRet = false;
    unsigned long nSize = 0;
    unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(fullpath, "rb", &nSize);
    if (pBuffer != NULL && nSize > 0)
    {
        bRet = initWithImageData(pBuffer, nSize, imageType);
    }
    CC_SAFE_DELETE_ARRAY(pBuffer);
    return bRet;
}

bool CCImage::initWithImageData(void * pData,
                                int nDataLen,
                                EImageFormat eFmt,
                                int nWidth,
                                int nHeight,
                                int nBitsPerComponent)
{
    bool bRet = false;
    tImageInfo info = {0};
    
    info.hasShadow = false;
    info.hasStroke = false;
    
    do
    {
        CC_BREAK_IF(! pData || nDataLen <= 0);
        if (eFmt == kFmtRawData)
        {
            bRet = _initWithRawData(pData, nDataLen, nWidth, nHeight, nBitsPerComponent, false);
        }
        else if (eFmt == kFmtWebp)
        {
            bRet = _initWithWebpData(pData, nDataLen);
        }
        else // init with png or jpg file data
        {
            bRet = _initWithData(pData, nDataLen, &info);
            if (bRet)
            {
                m_nHeight = (short)info.height;
                m_nWidth = (short)info.width;
                m_nBitsPerComponent = info.bitsPerComponent;
                m_bHasAlpha = info.hasAlpha;
                m_bPreMulti = info.isPremultipliedAlpha;
                m_pData = info.data;
            }
        }
    } while (0);
    
    return bRet;
}

bool CCImage::_initWithRawData(void *pData, int nDatalen, int nWidth, int nHeight, int nBitsPerComponent, bool bPreMulti)
{
    bool bRet = false;
    do
    {
        CC_BREAK_IF(0 == nWidth || 0 == nHeight);
        
        m_nBitsPerComponent = nBitsPerComponent;
        m_nHeight   = (short)nHeight;
        m_nWidth    = (short)nWidth;
        m_bHasAlpha = true;
        
        // only RGBA8888 supported
        int nBytesPerComponent = 4;
        int nSize = nHeight * nWidth * nBytesPerComponent;
        m_pData = new unsigned char[nSize];
        CC_BREAK_IF(! m_pData);
        memcpy(m_pData, pData, nSize);
        
        bRet = true;
    } while (0);
    return bRet;
}

bool CCImage::_initWithJpgData(void *pData, int nDatalen)
{
    assert(0);
	return false;
}
bool CCImage::_initWithPngPalette(void *png_data, void *info_data)
{
	png_structp png_ptr = (png_structp)png_data;
	png_infop  info_ptr = (png_infop)info_data;
    
	if (!png_ptr || !info_ptr)
		return false;
    
	// get alpha data
	bool hasAlpha = false;
	png_bytep trans_alpha = 0;
	int num_trans = 0;
	if (png_get_tRNS(png_ptr, info_ptr, &trans_alpha, &num_trans, 0) & PNG_INFO_tRNS)
		hasAlpha = true;
    
	// get background data
	bool hasBackground = false;
	png_color_16p background = 0;
	if (png_get_bKGD(png_ptr, info_ptr, &background) & PNG_INFO_bKGD)
		hasBackground = true;
    
	// get palette data
	png_colorp palette = 0;
	int num_palette = 0;
	png_get_PLTE(png_ptr, info_ptr, &palette, &num_palette);
    
	// create palette data
	m_sPaletteData.palette_num = num_palette;
	int palette_size = 256*4*sizeof(unsigned char);
	m_sPaletteData.palette_color = new unsigned char[palette_size];
	memset(m_sPaletteData.palette_color, 0, palette_size);
    
	//generate palette rgba data
	unsigned int* color_ptr = (unsigned int *)m_sPaletteData.palette_color;
	for (int i=0;i<256;i++)
	{
		if (i < num_palette)
			*color_ptr++ = CC_RGB_PREMULTIPLY_ALPHA(palette[i].red, palette[i].green, palette[i].blue, i < num_trans? trans_alpha[i] : 0xFF);
		else
			*color_ptr++ = 0;
	}
    
	// get palette index data
	png_uint_32 rowbytes = png_get_rowbytes(png_ptr, info_ptr);
	m_pData = new unsigned char[rowbytes * m_nHeight];
	memset(m_pData, 0 ,rowbytes * m_nHeight);
	png_bytep* row_pointers = (png_bytep*)malloc( sizeof(png_bytep) * m_nHeight);
	for (unsigned short i = 0; i < m_nHeight; ++i)
		row_pointers[i] = m_pData + i*rowbytes;
    
	// read palette data
	png_read_image(png_ptr, row_pointers);
	png_read_end(png_ptr, NULL);
	CC_SAFE_FREE(row_pointers);
    
	if (png_ptr)
		png_destroy_read_struct(&png_ptr, (info_ptr) ? &info_ptr : 0, 0);
    
	m_bHasAlpha = true;
	return true;
}

bool CCImage::_initWithPngData(void * pData, int nDatalen)
{
//--context difference from version 2.1.3 at com4loves@2013
    // length of bytes to check if it is a valid png file
#define PNGSIGSIZE  8
    bool bRet = false;
    png_byte        header[PNGSIGSIZE]   = {0};
    png_structp     png_ptr     =   0;
    png_infop       info_ptr    = 0;
    
    do
    {
        // png header len is 8 bytes
        CC_BREAK_IF(nDatalen < PNGSIGSIZE);
        
        // check the data is png or not
        memcpy(header, pData, PNGSIGSIZE);
        CC_BREAK_IF(png_sig_cmp(header, 0, PNGSIGSIZE));
        
        // init png_struct
        png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, 0, 0, 0);
        CC_BREAK_IF(! png_ptr);
        
        // init png_info
        info_ptr = png_create_info_struct(png_ptr);
        CC_BREAK_IF(!info_ptr);
        
#if (CC_TARGET_PLATFORM != CC_PLATFORM_BADA && CC_TARGET_PLATFORM != CC_PLATFORM_NACL)
        CC_BREAK_IF(setjmp(png_jmpbuf(png_ptr)));
#endif
        
        // set the read call back function
        tImageSource imageSource;
        imageSource.data    = (unsigned char*)pData;
        imageSource.size    = nDatalen;
        imageSource.offset  = 0;
        png_set_read_fn(png_ptr, &imageSource, pngReadCallback);
        
        // read png header info
        
        // read png file info
        png_read_info(png_ptr, info_ptr);
        
        m_nWidth = png_get_image_width(png_ptr, info_ptr);
        m_nHeight = png_get_image_height(png_ptr, info_ptr);
        m_nBitsPerComponent = png_get_bit_depth(png_ptr, info_ptr);
        png_uint_32 color_type = png_get_color_type(png_ptr, info_ptr);
        
        //CCLOG("color type %u", color_type);
        
        // force palette images to be expanded to 24-bit RGB
        // it may include alpha channel
        //begin add by hui, add the flag when use png8 for heiOutline24_0.png and tubiao_0.png
		bool usingPngFlag = false;
        if (color_type == PNG_COLOR_TYPE_PALETTE)
        {
			png_textp text_ptr;
			int num_text;
			if (png_get_text(png_ptr, info_ptr, &text_ptr, &num_text) > 0)
			{
				int i =0;
				char* key = "";
				key = text_ptr[i].key;
				char* text  = "";
				text = text_ptr[i].text;
				//CCLOG("@CCImage::_initWithPngData--  Text key[%d]=%d,Text text[%d]=%d\n",i, text_ptr[i].key,i,text_ptr[i].text);
				if((0 == strcmp(text,"true"))&& (0 == strcmp(key,"PngFlag"))){////verify the key and text, key is "PngFlag", text is "true".
					usingPngFlag = true;
				}
			}
			if (img_PaletteEnable && m_nBitsPerComponent == 8&&m_imgInPlist)
				return _initWithPngPalette(png_ptr, info_ptr);
			//end add by hui
            png_set_palette_to_rgb(png_ptr);
        }
        // low-bit-depth grayscale images are to be expanded to 8 bits
        if (color_type == PNG_COLOR_TYPE_GRAY && m_nBitsPerComponent < 8)
        {
            png_set_expand_gray_1_2_4_to_8(png_ptr);
        }
        // expand any tRNS chunk data into a full alpha channel
        if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS))
        {
            png_set_tRNS_to_alpha(png_ptr);
        }
        // reduce images with 16-bit samples to 8 bits
        if (m_nBitsPerComponent == 16)
        {
            png_set_strip_16(png_ptr);
        }
        // expand grayscale images to RGB
        if (color_type == PNG_COLOR_TYPE_GRAY || color_type == PNG_COLOR_TYPE_GRAY_ALPHA)
        {
            png_set_gray_to_rgb(png_ptr);
        }
        
        // read png data
        // m_nBitsPerComponent will always be 8
        m_nBitsPerComponent = 8;
        png_uint_32 rowbytes;
        png_bytep* row_pointers = (png_bytep*)malloc( sizeof(png_bytep) * m_nHeight );
        
        png_read_update_info(png_ptr, info_ptr);
        
        rowbytes = png_get_rowbytes(png_ptr, info_ptr);
        
        m_pData = new unsigned char[rowbytes * m_nHeight];
        CC_BREAK_IF(!m_pData);
        
        for (unsigned short i = 0; i < m_nHeight; ++i)
        {
            row_pointers[i] = m_pData + i*rowbytes;
        }
        png_read_image(png_ptr, row_pointers);
        
        png_read_end(png_ptr, NULL);
        
        png_uint_32 channel = rowbytes/m_nWidth;
        if (channel == 4)
        {
            m_bHasAlpha = true;
            unsigned int *tmp = (unsigned int *)m_pData;
            for(unsigned short i = 0; i < m_nHeight; i++)
            {
                for(unsigned int j = 0; j < rowbytes; j += 4)
                {
                    *tmp++ = CC_RGB_PREMULTIPLY_ALPHA( row_pointers[i][j], row_pointers[i][j + 1],
                                                      row_pointers[i][j + 2], row_pointers[i][j + 3] );
                }
            }
            
            m_bPreMulti = true;
        }
        
        CC_SAFE_FREE(row_pointers);
        
        bRet = true;
    } while (0);
    
    if (png_ptr)
    {
        png_destroy_read_struct(&png_ptr, (info_ptr) ? &info_ptr : 0, 0);
    }
    return bRet;
}

bool CCImage::_saveImageToPNG(const char *pszFilePath, bool bIsToRGB)
{
    assert(0);
	return false;
}

bool CCImage::_saveImageToJPG(const char *pszFilePath)
{
    assert(0);
	return false;
}

bool CCImage::initWithString(
                             const char * pText,
                             int         nWidth /* = 0 */,
                             int         nHeight /* = 0 */,
                             ETextAlign eAlignMask /* = kAlignCenter */,
                             const char * pFontName /* = nil */,
                             int         nSize /* = 0 */,
                             bool			bBold,
                             bool			bUnderline)
{
    return initWithStringShadowStroke(pText, nWidth, nHeight, eAlignMask , pFontName, nSize,NULL);
}

bool CCImage::initWithStringShadowStroke(
                                         const char * pText,
                                         int         nWidth ,
                                         int         nHeight ,
                                         ETextAlign eAlignMask ,
                                         const char * pFontName ,
                                         int         nSize ,
                                         struct _ccInitWithStringParam *param
)
{
    
    
    float textTintR   = 1;
    float textTintG   = 1;
    float textTintB   = 1;
    bool  shadow                 = false;
    float shadowOffsetX         = 0.0;
    float shadowOffsetY         = 0.0;
    float shadowOpacity         = 0.0;
    float shadowBlur            = 0.0;
    bool  stroke                =  false;
    float strokeR               = 1;
    float strokeG               = 1;
    float strokeB               = 1;
    float strokeSize            = 1;
    float shadowR               = 0;
    float shadowG               = 0;
    float shadowB               = 0;
    
    if(param!=NULL)
    {
        
        textTintR             = param->textTintR ;
        textTintG             = param->textTintG;
        textTintB             = param->textTintB;
        shadow                = param->shadow;
        shadowOffsetX         = param->shadowOffsetX;
        shadowOffsetY         = param->shadowOffsetY;
        shadowOpacity         = param->shadowOpacity;
        shadowBlur            = param->shadowBlur;
        stroke                = param->stroke;
        strokeR               = param->strokeR;
        strokeG               = param->strokeG;
        strokeB               = param->strokeB;
        strokeSize            = param->strokeSize;
        shadowR               = param->shadowR;
        shadowG               = param->shadowG;
        shadowB               = param->shadowB;
        

    }

    tImageInfo info = {0};
    info.width                  = nWidth;
    info.height                 = nHeight;
    info.hasShadow              = shadow;
    info.shadowOffset.width     = shadowOffsetX;
    info.shadowOffset.height    = shadowOffsetY;
    info.shadowBlur             = shadowBlur;
    info.shadowOpacity          = shadowOpacity;
    info.hasStroke              =  stroke;
    info.strokeColorR           =  strokeR;
    info.strokeColorG           = strokeG;
    info.strokeColorB           = strokeB;
    info.strokeSize             = strokeSize;
    info.tintColorR             = textTintR;
    info.tintColorG             = textTintG;
    info.tintColorB             = textTintB;
    info.shadowColorR             = shadowR;
    info.shadowColorG             = shadowG;
    info.shadowColorB             = shadowB;


    
    if (! _initWithString(pText, eAlignMask, pFontName, nSize, &info))
    {
        return false;
    }
    m_nHeight = (short)info.height;
    m_nWidth = (short)info.width;
    m_nBitsPerComponent = info.bitsPerComponent;
    m_bHasAlpha = info.hasAlpha;
    m_bPreMulti = info.isPremultipliedAlpha;
    m_pData = info.data;
    
    return true;
}


bool CCImage::saveToFile(const char *pszFilePath, bool bIsToRGB)
{
    bool saveToPNG = false;
    bool needToCopyPixels = false;
    std::string filePath(pszFilePath);
    if (std::string::npos != filePath.find(".png"))
    {
        saveToPNG = true;
    }
    
    int bitsPerComponent = 8;
    int bitsPerPixel = m_bHasAlpha ? 32 : 24;
    if ((! saveToPNG) || bIsToRGB)
    {
        bitsPerPixel = 24;
    }
    
    int bytesPerRow    = (bitsPerPixel/8) * m_nWidth;
    int myDataLength = bytesPerRow * m_nHeight;
    
    unsigned char *pixels    = m_pData;
    
    // The data has alpha channel, and want to save it with an RGB png file,
    // or want to save as jpg,  remove the alpha channel.
    if ((saveToPNG && m_bHasAlpha && bIsToRGB)
        || (! saveToPNG))
    {
        pixels = new unsigned char[myDataLength];
        
        for (int i = 0; i < m_nHeight; ++i)
        {
            for (int j = 0; j < m_nWidth; ++j)
            {
                pixels[(i * m_nWidth + j) * 3] = m_pData[(i * m_nWidth + j) * 4];
                pixels[(i * m_nWidth + j) * 3 + 1] = m_pData[(i * m_nWidth + j) * 4 + 1];
                pixels[(i * m_nWidth + j) * 3 + 2] = m_pData[(i * m_nWidth + j) * 4 + 2];
            }
        }
        
        needToCopyPixels = true;
    }
    
    // make data provider with data.
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    if (saveToPNG && m_bHasAlpha && (! bIsToRGB))
    {
        bitmapInfo |= kCGImageAlphaPremultipliedLast;
    }
    CGDataProviderRef provider        = CGDataProviderCreateWithData(NULL, pixels, myDataLength, NULL);
    CGColorSpaceRef colorSpaceRef    = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref                    = CGImageCreate(m_nWidth, m_nHeight,
                                                       bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                       colorSpaceRef, bitmapInfo, provider,
                                                       NULL, false,
                                                       kCGRenderingIntentDefault);
    
    UIImage* image                    = [[UIImage alloc] initWithCGImage:iref];
    
    CGImageRelease(iref);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    NSData *data;
    
    if (saveToPNG)
    {
        data = UIImagePNGRepresentation(image);
    }
    else
    {
        data = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    [data writeToFile:[NSString stringWithUTF8String:pszFilePath] atomically:YES];
    
    [image release];
    
    if (needToCopyPixels)
    {
        delete [] pixels;
    }
    
    return true;
}

NS_CC_END

