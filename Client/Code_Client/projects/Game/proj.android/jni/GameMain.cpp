#include "AppDelegate.h"
#include "cocos2d.h"
#include "CCEventType.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include <android/log.h>
#include "jni/Java_org_cocos2dx_lib_Cocos2dxHelper.h"

#define  LOG_TAG    "GameMain"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

using namespace cocos2d;

extern "C"
{
    
jint JNI_OnLoad(JavaVM *vm, void *reserved)
{
    JniHelper::setJavaVM(vm);

    return JNI_VERSION_1_6;
}

void Java_org_cocos2dx_lib_Cocos2dxRenderer_nativeInit(JNIEnv*  env, jobject thiz, jint w, jint h)
{
    if (!CCDirector::sharedDirector()->getOpenGLView())
    {
    	CCLOG("Java_org_cocos2dx_lib_Cocos2dxRenderer_nativeInit init");
        CCEGLView *view = CCEGLView::sharedOpenGLView();
        view->setFrameSize(w, h);

        AppDelegate *pAppDelegate = new AppDelegate();
        CCApplication::sharedApplication()->run();
    }
    else
    {
    	CCLOG("Java_org_cocos2dx_lib_Cocos2dxRenderer_nativeInit reload");
        ccDrawInit();
        ccGLInvalidateStateCache();

        CCShaderCache::sharedShaderCache()->reloadDefaultShaders();
        CCTextureCache::reloadAllTextures();
        CCNotificationCenter::sharedNotificationCenter()->postNotification(EVNET_COME_TO_FOREGROUND, NULL);
        CCDirector::sharedDirector()->setGLDefaultValues(); 
        CCDirector::sharedDirector()->setDirty(true);
    }
}

	//begin
	/*
		GameApp在各个平台的appid、appkey、各种secret等数字，字符串，
		在java代码很容易被反编译，
		硬编码在c++代码，提高反编译难度，
		如果需要，可进一步加密字符串，
		按json格式传到java，好解析
	*/
	static char gamePlatformNd91[] = "{ \"appid\":\"112727\", \"appkey\":\"1f44424ae0be1bb982e50f9cca953c6788d0596189d8f21c\"}";
	
	static char gamePlatformUC[] = "{ \"cpid\":\"44621\", \"appid\":\"544772\", \"svrid\":\"2865\", \"appkey\":\"c90b05265e5bb862b6c3c4fe1a11d3fb\"}";
	
	static char gamePlatformGoogle[] = "{ \"appid\":\"25\",\"appkey\":\"league\",\"appsecret\":\"leagueandeljoqlzpleiclqoqc\",\"rechargeurl\":\"http://182.254.201.94/callback/googlepay/\",\"public_str\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAonXlxMTIz8zwwhS0otKkzF6b2aKcvMl0Ye3fQhLhm85jfRWya0x845kqaFG1nxSizJQY3niE0hiVvbKtFB8ssT4ma4tU9byLBDtTUwKX2mqc4q01C5nGSon3ocllgskgfmXEKGRejbhxDb9qu4hL0O5gZPnLPIyba8NqAgb9iYnXVXp8me4XahnhzBBn+yHRP8dmR0IrpixswdKmEuvyF/M96ix3xmr4CfRAK51mOjDtciq4CXlbsFZTi+TIg0cvLpwktw37g3HYCpkmp9ocuWGBlH1DO4ug6ZLrziOZNK0/Do1t72pt+axwWlk0zncsqwlXldL8BN12LapoDBk2TQIDAQAB\"}";
	JNIEXPORT jstring JNICALL Java_com_nuclear_dragonb_GameConfig_nativeReadGamePlatformInfo(JNIEnv*  env, jobject thiz,
			jint platform_type)
	{
		if (platform_type == 1)
		{
			//enPlatform_91
			return JniHelper::string2jstring(gamePlatformNd91);
		}
		if (platform_type == 2)
		{
			//enPlatform_91
			return JniHelper::string2jstring(gamePlatformUC);
		}
		if (platform_type == 53)
		{
					//enPlatform_googleFt
			return JniHelper::string2jstring(gamePlatformGoogle);
		}
		return 0;
	}
	//--end
}
