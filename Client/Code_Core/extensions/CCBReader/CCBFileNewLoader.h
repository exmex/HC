#ifndef _CCB_CCBFILENEWLOADER_H_
#define _CCB_CCBFILENEWLOADER_H_

#include "CCNodeLoader.h"
#include "CCBReader.h"
#include "CCBFileNew.h"

NS_CC_EXT_BEGIN

/* Forward declaration. */
class CCBReader;
/**
 *  @js NA
 *  @lua NA
 */
class CCBFileNewLoader : public CCNodeLoader {
    public:
        virtual ~CCBFileNewLoader() {};
        CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(CCBFileNewLoader, loader);

    protected:
        CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(CCBFileNew);

        virtual void onHandlePropTypeCCBFileNew(CCNode * pNode, CCNode * pParent, const char * pPropertyName, CCNode * pCCBFileNode, CCBReader * pCCBReader);
};

NS_CC_EXT_END

#endif
