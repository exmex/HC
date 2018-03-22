#include "CCLabelBMFontLoader.h"



NS_CC_EXT_BEGIN

#define PROPERTY_COLOR "color"
#define PROPERTY_OPACITY "opacity"
#define PROPERTY_BLENDFUNC "blendFunc"
#define PROPERTY_FNTFILE "fntFile"
#define PROPERTY_STRING "string"


#define PROPERTY_BMFONT_SHADOW_ENABLE "shadowEnabled"
#define PROPERTY_BMFONT_SHADOW_COLOR "shadowColor"
#define PROPERTY_BMFONT_SHADOW_OFFSET "shadowOffset"
#define PROPERTY_BMFONT_SHADOW_OFFSET2 "shadowOffset2"
#define PROPERTY_BMFONT_SHADOW_OFFSET3 "shadowOffset3"
#define PROPERTY_BMFONT_SHADOW_OFFSET4 "shadowOffset4"
#define PROPERTY_BMFONT_SHADOW_FOUR_DIR "fourDirEnabled"

#define PROPERTY_BMFONT_FADE_ENABLE "fadeEnabled"
#define PROPERTY_BMFONT_FADE_IMAGE "fadeImage"

void CCLabelBMFontLoader::onHandlePropTypeCheck(CCNode * pNode, CCNode * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader) {
		if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_ENABLE) == 0) {
			((CCLabelBMFont *)pNode)->setTextShadowEnabled(pCheck);
		}if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_FOUR_DIR) == 0) {
			((CCLabelBMFont *)pNode)->setTextShadowFourDirEnabled(pCheck);
		}if(strcmp(pPropertyName, PROPERTY_BMFONT_FADE_ENABLE) == 0) {
			((CCLabelBMFont *)pNode)->setTextFadeEnabled(pCheck);
		} else {
			//ASSERT_FAIL_UNEXPECTED_PROPERTY(pPropertyName);
			// It may be a custom property, add it to custom property dictionary.
			CCNodeLoader::onHandlePropTypeCheck(pNode, pParent,pPropertyName, pCheck, pCCBReader) ;
		}
}

void CCLabelBMFontLoader::onHandlePropTypeSpriteFrame(CCNode * pNode, CCNode * pParent, const char * pPropertyName, CCSpriteFrame * pCCSpriteFrame, CCBReader * pCCBReader) {
		if(strcmp(pPropertyName, PROPERTY_BMFONT_FADE_IMAGE) == 0) {
			if(pCCSpriteFrame != NULL) {
				((CCLabelBMFont *)pNode)->setFadeTexture(pCCSpriteFrame->getTexture());
			} else {
				CCLOG("ERROR: SpriteFrame NULL");
			}
		} else {
			CCNodeLoader::onHandlePropTypeSpriteFrame(pNode, pParent, pPropertyName, pCCSpriteFrame, pCCBReader);
		}
}


void CCLabelBMFontLoader::onHandlePropTypePoint(CCNode * pNode, CCNode * pParent, const char* pPropertyName, CCPoint pPoint, CCBReader * pCCBReader) {
	if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_OFFSET) == 0) {
		((CCLabelBMFont *)pNode)->setTexShadowOffset(pPoint.x,pPoint.y);
	}else if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_OFFSET2) == 0) {
		((CCLabelBMFont *)pNode)->setTexShadowOffset2(pPoint.x,pPoint.y);
	} else if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_OFFSET3) == 0) {
		((CCLabelBMFont *)pNode)->setTexShadowOffset3(pPoint.x,pPoint.y);
	}else if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_OFFSET4) == 0) {
		((CCLabelBMFont *)pNode)->setTexShadowOffset4(pPoint.x,pPoint.y);
	}else {
		CCNodeLoader::onHandlePropTypePoint( pNode, pParent, pPropertyName, pPoint,  pCCBReader);
	}
}

void CCLabelBMFontLoader::onHandlePropTypeColor3(CCNode * pNode, CCNode * pParent, const char * pPropertyName, ccColor3B pCCColor3B, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_COLOR) == 0) {
        ((CCLabelBMFont *)pNode)->setColor(pCCColor3B);
	}else if(strcmp(pPropertyName, PROPERTY_BMFONT_SHADOW_COLOR) == 0) {
		((CCLabelBMFont *)pNode)->setTextShadowColor(pCCColor3B.r/255.0,pCCColor3B.g/255.0,pCCColor3B.b/255.0,1.0);
	} else {
        CCNodeLoader::onHandlePropTypeColor3(pNode, pParent, pPropertyName, pCCColor3B, pCCBReader);
    }
}

void CCLabelBMFontLoader::onHandlePropTypeByte(CCNode * pNode, CCNode * pParent, const char * pPropertyName, unsigned char pByte, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_OPACITY) == 0) {
        ((CCLabelBMFont *)pNode)->setOpacity(pByte);
    } else {
        CCNodeLoader::onHandlePropTypeByte(pNode, pParent, pPropertyName, pByte, pCCBReader);
    }
}

void CCLabelBMFontLoader::onHandlePropTypeBlendFunc(CCNode * pNode, CCNode * pParent, const char * pPropertyName, ccBlendFunc pCCBlendFunc, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_BLENDFUNC) == 0) {
        ((CCLabelBMFont *)pNode)->setBlendFunc(pCCBlendFunc);
    } else {
        CCNodeLoader::onHandlePropTypeBlendFunc(pNode, pParent, pPropertyName, pCCBlendFunc, pCCBReader);
    }
}

void CCLabelBMFontLoader::onHandlePropTypeFntFile(CCNode * pNode, CCNode * pParent, const char * pPropertyName, const char* pFntFile, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_FNTFILE) == 0) {
        ((CCLabelBMFont *)pNode)->setFntFile(pFntFile);
    } else {
        CCNodeLoader::onHandlePropTypeFntFile(pNode, pParent, pPropertyName, pFntFile, pCCBReader);
    }
}

void CCLabelBMFontLoader::onHandlePropTypeText(CCNode * pNode, CCNode * pParent, const char * pPropertyName, const char* pText, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_STRING) == 0) {
        ((CCLabelBMFont *)pNode)->setString(pText);
    } else {
        CCNodeLoader::onHandlePropTypeText(pNode, pParent, pPropertyName, pText, pCCBReader);
    }
}

NS_CC_EXT_END