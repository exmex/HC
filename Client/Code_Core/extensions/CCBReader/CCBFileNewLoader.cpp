#include "CCBFileNewLoader.h"



NS_CC_EXT_BEGIN

#define PROPERTY_CCBFILE "ccbFile"

void CCBFileNewLoader::onHandlePropTypeCCBFileNew(CCNode * pNode, CCNode * pParent, const char * pPropertyName, CCNode * pCCBFileNode, CCBReader * pCCBReader) {
    if(strcmp(pPropertyName, PROPERTY_CCBFILE) == 0) {
        //((CCBFile*)pNode)->setCCBFileNode(pCCBFileNode);
    } else {
        CCNodeLoader::onHandlePropTypeCCBFileNew(pNode, pParent, pPropertyName, pCCBFileNode, pCCBReader);
    }
}

NS_CC_EXT_END
