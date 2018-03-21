#ifndef __CC_APPLICATION_ANDROID_H__
#define __CC_APPLICATION_ANDROID_H__

#include "platform/CCCommon.h"
#include "platform/CCApplicationProtocol.h"

NS_CC_BEGIN

class CCRect;

class CC_DLL CCApplication : public CCApplicationProtocol
{
public:
    CCApplication();
    virtual ~CCApplication();

    /**
    @brief    Callback by CCDirector to limit FPS.
    @interval       The time, expressed in seconds, between current frame and next. 
    */
    void setAnimationInterval(double interval);

    /**
    @brief    Run the message loop.
    */
    int run();

    /**
    @brief    Get current application instance.
    @return Current application instance pointer.
    */
    static CCApplication* sharedApplication();

    /**
    @brief Get current language config
    @return Current language config
    */
    virtual ccLanguageType getCurrentLanguage();
    
    /**
     @brief Get target platform
     */
    virtual TargetPlatform getTargetPlatform();


    virtual void restart();
    virtual bool isRestarting();
    virtual void restartDone();

	//--begin xinzheng 2013-6-3
	/*
	GameApp具体实现上层自己的清理
	CCDirector::end()只触发了引擎层面及内部的清理
	*/
	virtual void applicationWillGoToExit() {};
	//--end

protected:
    static CCApplication * sm_pSharedApplication;
    bool m_isRestarting;
};

NS_CC_END

#endif    // __CC_APPLICATION_ANDROID_H__
