#include "CCMenuItemCCBFileLoader.h"
#include "CCBReader.h"
#include "GUI/CCMenuCCBFile.h"
#include "CCBFileNew.h"

NS_CC_EXT_BEGIN
void CCMenuItemCCBFileLoader::onHandlePropTypeCCBFileNew(CCNode * pNode, CCNode * pParent, const char* pPropertyName, CCNode * pCCBFileNode, CCBReader * pCCBReader)
{
	if(strcmp(pPropertyName, "ccbFile") == 0) {
		 ((CCMenuItemCCBFile *)pNode)->setCCBFile((CCBFileNew*)pCCBFileNode);
	} 
	 else {
		CCMenuItemLoader::onHandlePropTypeCCBFileNew(pNode, pParent, pPropertyName, pCCBFileNode, pCCBReader);
	}

}

NS_CC_EXT_END
