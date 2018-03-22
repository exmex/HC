#include "CCLabelTTFLoader.h"



#define PROPERTY_COLOR "color"
#define PROPERTY_OPACITY "opacity"
#define PROPERTY_BLENDFUNC "blendFunc"
#define PROPERTY_FONTNAME "fontName"
#define PROPERTY_FONTSIZE "fontSize"
#define PROPERTY_HORIZONTALALIGNMENT "horizontalAlignment"
#define PROPERTY_VERTICALALIGNMENT "verticalAlignment"
#define PROPERTY_STRING "string"
#define PROPERTY_DIMENSIONS "dimensions"
#define PROPERTY_TTF_SHADOW_ENABLE "shadowEnabled"
#define PROPERTY_TTF_SHADOW_COLOR "shadowColor"
#define PROPERTY_TTF_SHADOW_OFFSET "shadowOffset"
#define PROPERTY_TTF_SHADOW_OFFSET2 "shadowOffset2"
#define PROPERTY_TTF_SHADOW_OFFSET3 "shadowOffset3"
#define PROPERTY_TTF_SHADOW_OFFSET4 "shadowOffset4"
#define PROPERTY_TTF_SHADOW_FOUR_DIR "fourDirEnabled"

#define PROPERTY_TTF_FADE_ENABLE "fadeEnabled"
#define PROPERTY_TTF_FADE_IMAGE "fadeImage"



NS_CC_EXT_BEGIN

void CCLabelTTFLoader::onHandlePropTypeColor3(CCNode * pNode, CCNode * pParent, const char * pPropertyName, ccColor3B pCCColor3B, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_COLOR) == 0) {
        ((CCLabelTTF *)pNode)->setColor(pCCColor3B);
	}else if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_COLOR) == 0) {
		((CCLabelTTF *)pNode)->setTextShadowColor(pCCColor3B.r/255.0,pCCColor3B.g/255.0,pCCColor3B.b/255.0,1.0);
	} else {
        CCNodeLoader::onHandlePropTypeColor3(pNode, pParent, pPropertyName, pCCColor3B, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypePoint(CCNode * pNode, CCNode * pParent, const char* pPropertyName, CCPoint pPoint, CCBReader * pCCBReader) {
	if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_OFFSET) == 0) {
		 ((CCLabelTTF *)pNode)->setTexShadowOffset(pPoint.x,pPoint.y);
	}else if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_OFFSET2) == 0) {
		((CCLabelTTF *)pNode)->setTexShadowOffset2(pPoint.x,pPoint.y);
	} else if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_OFFSET3) == 0) {
		((CCLabelTTF *)pNode)->setTexShadowOffset3(pPoint.x,pPoint.y);
	}else if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_OFFSET4) == 0) {
		((CCLabelTTF *)pNode)->setTexShadowOffset4(pPoint.x,pPoint.y);
	}else {
		CCNodeLoader::onHandlePropTypePoint( pNode, pParent, pPropertyName, pPoint,  pCCBReader);
	}
}


void CCLabelTTFLoader::onHandlePropTypeCheck(CCNode * pNode, CCNode * pParent, const char* pPropertyName, bool pCheck, CCBReader * pCCBReader) {
	if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_ENABLE) == 0) {
		 ((CCLabelTTF *)pNode)->setTextShadowEnabled(pCheck);
	}if(strcmp(pPropertyName, PROPERTY_TTF_SHADOW_FOUR_DIR) == 0) {
		((CCLabelTTF *)pNode)->setTextShadowFourDirEnabled(pCheck);
	}if(strcmp(pPropertyName, PROPERTY_TTF_FADE_ENABLE) == 0) {
		((CCLabelTTF *)pNode)->setTextFadeEnabled(pCheck);
	} else {
		//ASSERT_FAIL_UNEXPECTED_PROPERTY(pPropertyName);
		// It may be a custom property, add it to custom property dictionary.
		CCNodeLoader::onHandlePropTypeCheck(pNode, pParent,pPropertyName, pCheck, pCCBReader) ;
	}
}

void CCLabelTTFLoader::onHandlePropTypeSpriteFrame(CCNode * pNode, CCNode * pParent, const char * pPropertyName, CCSpriteFrame * pCCSpriteFrame, CCBReader * pCCBReader) {
	if(strcmp(pPropertyName, PROPERTY_TTF_FADE_IMAGE) == 0) {
		if(pCCSpriteFrame != NULL) {
			((CCLabelTTF *)pNode)->setFadeTexture(pCCSpriteFrame->getTexture());
		} else {
			CCLOG("ERROR: SpriteFrame NULL");
		}
	} else {
		CCNodeLoader::onHandlePropTypeSpriteFrame(pNode, pParent, pPropertyName, pCCSpriteFrame, pCCBReader);
	}
}


void CCLabelTTFLoader::onHandlePropTypeByte(CCNode * pNode, CCNode * pParent, const char * pPropertyName, unsigned char pByte, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_OPACITY) == 0) {
        ((CCLabelTTF *)pNode)->setOpacity(pByte);
    } else {
        CCNodeLoader::onHandlePropTypeByte(pNode, pParent, pPropertyName, pByte, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypeBlendFunc(CCNode * pNode, CCNode * pParent, const char * pPropertyName, ccBlendFunc pCCBlendFunc, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_BLENDFUNC) == 0) {
        ((CCLabelTTF *)pNode)->setBlendFunc(pCCBlendFunc);
    } else {
        CCNodeLoader::onHandlePropTypeBlendFunc(pNode, pParent, pPropertyName, pCCBlendFunc, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypeFontTTF(CCNode * pNode, CCNode * pParent, const char * pPropertyName, const char * pFontTTF, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_FONTNAME) == 0) {
        ((CCLabelTTF *)pNode)->setFontName(pFontTTF);
    } else {
        CCNodeLoader::onHandlePropTypeFontTTF(pNode, pParent, pPropertyName, pFontTTF, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypeText(CCNode * pNode, CCNode * pParent, const char * pPropertyName, const char * pText, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_STRING) == 0) {
        ((CCLabelTTF *)pNode)->setString(pText);
    } else {
        CCNodeLoader::onHandlePropTypeText(pNode, pParent, pPropertyName, pText, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypeFloatScale(CCNode * pNode, CCNode * pParent, const char * pPropertyName, float pFloatScale, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_FONTSIZE) == 0) {
        ((CCLabelTTF *)pNode)->setFontSize(pFloatScale);
    } else {
        CCNodeLoader::onHandlePropTypeFloatScale(pNode, pParent, pPropertyName, pFloatScale, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypeIntegerLabeled(CCNode * pNode, CCNode * pParent, const char * pPropertyName, int pIntegerLabeled, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_HORIZONTALALIGNMENT) == 0) {
        ((CCLabelTTF *)pNode)->setHorizontalAlignment(CCTextAlignment(pIntegerLabeled));
    } else if(strcmp(pPropertyName, PROPERTY_VERTICALALIGNMENT) == 0) {
        ((CCLabelTTF *)pNode)->setVerticalAlignment(CCVerticalTextAlignment(pIntegerLabeled));
    } else {
        CCNodeLoader::onHandlePropTypeFloatScale(pNode, pParent, pPropertyName, pIntegerLabeled, pCCBReader);
    }
}

void CCLabelTTFLoader::onHandlePropTypeSize(CCNode * pNode, CCNode * pParent, const char * pPropertyName, CCSize pSize, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_DIMENSIONS) == 0) {
        ((CCLabelTTF *)pNode)->setDimensions(pSize);
    } else {
        CCNodeLoader::onHandlePropTypeSize(pNode, pParent, pPropertyName, pSize, pCCBReader);
    }
}

NS_CC_EXT_END