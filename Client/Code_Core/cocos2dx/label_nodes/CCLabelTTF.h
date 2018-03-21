/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada

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
#ifndef __CCLABELTTF_H__
#define __CCLABELTTF_H__

#include "sprite_nodes/CCSprite.h"
#include "textures/CCTexture2D.h"

NS_CC_BEGIN

/**
 * @addtogroup GUI
 * @{
 * @addtogroup label
 * @{
 */



/** @brief CCLabelTTF is a subclass of CCTextureNode that knows how to render text labels
 *
 * All features from CCTextureNode are valid in CCLabelTTF
 *
 * CCLabelTTF objects are slow. Consider using CCLabelAtlas or CCLabelBMFont instead.
 *
 * Custom ttf file can be put in assets/ or external storage that the Application can access.
 * @code
 * CCLabelTTF *label1 = CCLabelTTF::create("alignment left", "A Damn Mess", fontSize, blockSize, 
 *                                          kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter);
 * CCLabelTTF *label2 = CCLabelTTF::create("alignment right", "/mnt/sdcard/Scissor Cuts.ttf", fontSize, blockSize,
 *                                          kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter);
 * @endcode
 *
 */
class CC_DLL CCLabelTTF : public CCSprite, public CCLabelProtocol
{
public:
    /**
     *  @js ctor
     */
    CCLabelTTF();
    /**
     *  @js NA
     *  @lua NA
     */
    virtual ~CCLabelTTF();
    /**
     *  @js NA
     *  @lua NA
     */
    const char* description();
    
    /** creates a CCLabelTTF with a font name and font size in points
     @since v2.0.1
     */
    static CCLabelTTF * create(const char *string, const char *fontName, float fontSize);
    
    /** creates a CCLabelTTF from a fontname, horizontal alignment, dimension in points,  and font size in points.
     @since v2.0.1
     */
    static CCLabelTTF * create(const char *string, const char *fontName, float fontSize,
                               const CCSize& dimensions, CCTextAlignment hAlignment);
  
    /** creates a CCLabel from a fontname, alignment, dimension in points and font size in points
     @since v2.0.1
     */
    static CCLabelTTF * create(const char *string, const char *fontName, float fontSize,
                               const CCSize& dimensions, CCTextAlignment hAlignment, 
							   CCVerticalTextAlignment vAlignment,
							   bool bBold = false, bool bUnderline = false);
    /** Create a lable with string and a font definition*/
    static CCLabelTTF * createWithFontDefinition(const char *string, ccFontDefinition &textDefinition);
    
    /** initializes the CCLabelTTF with a font name and font size */
    bool initWithString(const char *string, const char *fontName, float fontSize);
    
    /** initializes the CCLabelTTF with a font name, alignment, dimension and font size */
    bool initWithString(const char *string, const char *fontName, float fontSize,
                        const CCSize& dimensions, CCTextAlignment hAlignment);

    /** initializes the CCLabelTTF with a font name, alignment, dimension and font size */
    bool initWithString(const char *string, const char *fontName, float fontSize,
                        const CCSize& dimensions, CCTextAlignment hAlignment, 
                        CCVerticalTextAlignment vAlignment,
						bool bBold = false, bool bUnderline = false);
    /** initializes the CCLabelTTF with a font name, alignment, dimension and font size */
    bool initWithStringAndTextDefinition(const char *string, ccFontDefinition &textDefinition);
    
    /** set the text definition used by this label */
    void setTextDefinition(ccFontDefinition *theDefinition);
    
    /** get the text definition used by this label */
    ccFontDefinition * getTextDefinition();
    
    


    
    
    /** initializes the CCLabelTTF */
    bool init();

    /** Creates an label.
     */
    static CCLabelTTF * create();

    /** changes the string to render
    * @warning Changing the string is as expensive as creating a new CCLabelTTF. To obtain better performance use CCLabelAtlas
    */
    virtual void setString(const char *label);
    virtual const char* getString(void);
    
	void setStringWithFontInfo(const char* label, bool bBold, bool bUnderline);

    CCTextAlignment getHorizontalAlignment();
    void setHorizontalAlignment(CCTextAlignment alignment);
    
    CCVerticalTextAlignment getVerticalAlignment();
    void setVerticalAlignment(CCVerticalTextAlignment verticalAlignment);
    
    CCSize getDimensions();
    void setDimensions(const CCSize &dim);
    
    float getFontSize();
    void setFontSize(float fontSize);
    
    const char* getFontName();
    void setFontName(const char *fontName);
    //TODO--
    virtual void setShadow(ccColor3B color, const CCPoint& offset, float shadowBlur=0.0);
    virtual void setStroke(ccColor3B color, float size);

    
    
    /** enable or disable shadow for the label */
    void enableShadow(ccColor3B tintColor, const CCSize &shadowOffset, float shadowOpacity, float shadowBlur, bool mustUpdateTexture = true);
    
    /** disable shadow rendering */
    void disableShadow(bool mustUpdateTexture = true);
    
    /** enable or disable stroke */
    void enableStroke(const ccColor3B &strokeColor, float strokeSize, bool mustUpdateTexture = true);
    
    /** disable stroke */
    void disableStroke(bool mustUpdateTexture = true);
    
    /** set text tinting */
    void setFontFillColor(const ccColor3B &tintColor, bool mustUpdateTexture = true);
    

	//virtual void updateDisplayedColor(const ccColor3B& parentColor);
	
	virtual void enableOutline(const ccColor4B& outlineColor, int outlineSize = -1);
	virtual void updateShaderProgram();
	ccColor4F _effectColorF;

	void setPosition(const CCPoint& pos);
	void setFadeTexture(CCTexture2D * tex);
	void setTextShadowEnabled(bool textShadowEnabled);
	bool getTextShadowEnabled();
	void setTextShadowFourDirEnabled(bool fourDirEnable);
	//for the mimic of bord
	bool getTextShadowFourDirEnabled();
	void setTexShadowOffset(float shadowOffsetX,float shadowOffsetY);
	//shadow offset 2-4 only used for the four direction shadow used for the mimic of bord
	void setTexShadowOffset2(float shadowOffsetX,float shadowOffsetY);
	void setTexShadowOffset3(float shadowOffsetX,float shadowOffsetY);
	void setTexShadowOffset4(float shadowOffsetX,float shadowOffsetY);
	void setTextShadowColor(float _r, float _g, float _b, float _a);

	void setTextFadeEnabled(bool textFadeEnabled);
	bool getTextFadeEnabled();

	void setTextBorderEnabled(bool textBorderEnabled);
	bool getTextBorderEnabled();
	void setTextBorderColor(float _r, float _g, float _b, float _a = 0.0);


	void setTextFadeImageURL(std::string fadeImageUrl);

private:
    bool updateTexture(bool bBold = false, bool bUnderline = false);
	void updateContent();
	void updateStrokeNode();
  //  CCTexture2D *getStringTexture(cocos2d::_ccColor3B * clr);
	void updateColorTTF();
	void updateDisplayedOpacity(GLubyte parentOpacity);
	void drawStroke(CCTexture2D *tex);
	
protected:
    /** set the text definition for this label */
    void                _updateWithTextDefinition(ccFontDefinition & textDefinition, bool mustUpdateTexture = true);
    ccFontDefinition    _prepareTextDefinition(bool adjustForResolution = false);
    
    /** Dimensions of the label in Points */
    CCSize m_tDimensions;
    /** The alignment of the label */
    CCTextAlignment         m_hAlignment;
    /** The vertical alignment of the label */
    CCVerticalTextAlignment m_vAlignment;
    /** Font name used in the label */
    std::string * m_pFontName;
    /** Font size of the label */
    float m_fFontSize;
    /** label's string */
    std::string m_string;
    
    /** font shadow */
    bool    m_shadowEnabled;
    CCSize  m_shadowOffset;
    float   m_shadowOpacity;
    float   m_shadowBlur;
    //ccColor3B  m_shadowColor;
    
    /** font stroke */
    bool        m_strokeEnabled;
    ccColor3B   m_strokeColor;
    float       m_strokeSize;
    
    /** font tint */
    ccColor3B   m_textFillColor;
    
	CCSprite* _textSprite;
	CCSprite* _shadowNode;
	bool bSetOpacity;

	CCSprite* _strokeTextNode;
	CCSprite* _strokeNode1;
	CCSprite* _strokeNode2;
	CCSprite* _strokeNode3;
	CCSprite* _strokeNode4;
//    bool  m_enabledShadow;      //+0x1E0  = 0xF0 *2
//    ccColor3B m_shadowColor;   //+0x1E1 0x1E2 0x1E3
//    CCPoint   m_shawdowOffset; //+0x1E4
//    void   *  m_unk1e8;  //+0x1e8
//    bool m_enabledStroke;  //+0x1EC = 0xf6 *2
//    ccColor3B m_strokeColor;//+0x1ED 0x1EE 0x1EF
//    float m_strokeThickness; //+0x1F0
//    ccColor3B  m_texColor;  // +0x1f4
//    int ** m_unk1f8;  //+0x1f8
    
	bool m_textShadowEnabled;
	bool m_textShadowFourDirEnabled;
	bool m_textFadeEnabled;
	bool m_textBorderEnabled;

	std::string m_textFadeImageURL;

	float	m_fShadowOffsetX; //offset x based on the pixel
	float	m_fShadowOffsetY; //offset y based on the pixel

	float	m_fShadowOffsetX2; //offset x based on the pixel
	float	m_fShadowOffsetY2; //offset y based on the pixel

	float	m_fShadowOffsetX3; //offset x based on the pixel
	float	m_fShadowOffsetY3; //offset y based on the pixel

	float	m_fShadowOffsetX4; //offset x based on the pixel
	float	m_fShadowOffsetY4; //offset y based on the pixel

	void renderShadow(void);

	void renderFade(void);

	void renderBorder(void);

public:
	virtual void draw(void);

	CCTexture2D* m_fadeTexture;
	ccColor4F m_shadowColor;
	ccColor4F m_borderColor;

};


// end of GUI group
/// @}
/// @}

NS_CC_END

#endif //__CCLABEL_H__

