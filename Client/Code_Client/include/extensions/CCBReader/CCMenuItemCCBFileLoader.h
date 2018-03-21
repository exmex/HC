#ifndef _CCB_CCMENUITEMCCBFILELOADER_H_
#define _CCB_CCMENUITEMCCBFILELOADER_H_

#include "CCMenuItemLoader.h"
#include "GUI/CCMenuCCBFile.h"

NS_CC_EXT_BEGIN

/* Forward declaration. */
class CCBReader;


class CCMenuItemCCBFileLoader : public CCMenuItemLoader {
    public:
        virtual ~CCMenuItemCCBFileLoader() {};
        CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(CCMenuItemCCBFileLoader, loader);

    protected:
        CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(CCMenuItemCCBFile);

        virtual void onHandlePropTypeCCBFileNew(CCNode * pNode, CCNode * pParent, const char* pPropertyName, CCNode * pCCBFileNode, CCBReader * pCCBReader);
};

NS_CC_EXT_END

#endif
