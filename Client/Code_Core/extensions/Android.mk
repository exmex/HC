LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE    := cocos_extension_static

LOCAL_MODULE_FILENAME := libextension

LOCAL_SRC_FILES := AssetsManager/AssetsManager.cpp \
CCBReader/CCBFileLoader.cpp \
CCBReader/CCBFileNew.cpp \
CCBReader/CCBFileNewLoader.cpp \
CCBReader/CCMenuItemCCBFileLoader.cpp \
CCBReader/CCBClippingNode.cpp \
CCBReader/CCClippingNodeLoader.cpp \
CCBReader/CCBClippingNodeLoader.cpp \
CCBReader/CCBReader.cpp \
CCBReader/CCControlButtonLoader.cpp \
CCBReader/CCControlLoader.cpp \
CCBReader/CCLabelBMFontLoader.cpp \
CCBReader/CCLabelTTFLoader.cpp \
CCBReader/CCLayerColorLoader.cpp \
CCBReader/CCLayerGradientLoader.cpp \
CCBReader/CCLayerLoader.cpp \
CCBReader/CCMenuItemImageLoader.cpp \
CCBReader/CCMenuItemLoader.cpp \
CCBReader/CCNodeLoader.cpp \
CCBReader/CCNodeLoaderLibrary.cpp \
CCBReader/CCParticleSystemQuadLoader.cpp \
CCBReader/CCScale9SpriteLoader.cpp \
CCBReader/CCScrollViewLoader.cpp \
CCBReader/CCSpriteLoader.cpp \
CCBReader/CCBAnimationManager.cpp \
CCBReader/CCBKeyframe.cpp \
CCBReader/CCBSequence.cpp \
CCBReader/CCBSequenceProperty.cpp \
CCBReader/CCBValue.cpp \
CCBReader/CCData.cpp \
CCBReader/CCNode+CCBRelativePositioning.cpp \
GUI/CCMenuCCBFile.cpp	\
GUI/CCControlExtension/CCControl.cpp \
GUI/CCControlExtension/CCControlButton.cpp \
GUI/CCControlExtension/CCControlColourPicker.cpp \
GUI/CCControlExtension/CCControlHuePicker.cpp \
GUI/CCControlExtension/CCControlSaturationBrightnessPicker.cpp \
GUI/CCControlExtension/CCControlSlider.cpp \
GUI/CCControlExtension/CCControlSwitch.cpp \
GUI/CCControlExtension/CCControlUtils.cpp \
GUI/CCControlExtension/CCInvocation.cpp \
GUI/CCControlExtension/CCScale9Sprite.cpp \
GUI/CCControlExtension/CCControlPotentiometer.cpp \
GUI/CCControlExtension/CCControlStepper.cpp \
GUI/CCScrollView/CCScrollView.cpp \
GUI/CCScrollView/CCTableView.cpp \
GUI/CCScrollView/CCTableViewCell.cpp \
GUI/CCScrollView/CCSorting.cpp \
GUI/CCEditBox/CCEditBox.cpp \
GUI/CCEditBox/CCEditBoxImplAndroid.cpp \
network/HttpClient.cpp \
spine/Animation.c \
spine/AnimationState.c \
spine/AnimationStateData.c \
spine/Atlas.c \
spine/AtlasAttachmentLoader.c \
spine/Attachment.c \
spine/AttachmentLoader.c \
spine/Bone.c \
spine/BoneData.c \
spine/BoundingBoxAttachment.c \
spine/Event.c \
spine/EventData.c \
spine/extension.c \
spine/Json.c \
spine/MeshAttachment.c \
spine/RegionAttachment.c \
spine/Skeleton.c \
spine/SkeletonBounds.c \
spine/SkeletonData.c \
spine/SkeletonJson.c \
spine/Skin.c \
spine/SkinnedMeshAttachment.c \
spine/Slot.c \
spine/SlotData.c \
spine/PolygonBatch.cpp \
spine/SkeletonAnimation.cpp \
spine/SkeletonRenderer.cpp \
spine/spine-cocos2dx.cpp \
dfont/dfont_manager.cpp \
dfont/dfont_render.cpp \
dfont/dfont_utility.cpp \
RichControls/CCRichNode.cpp \
RichControls/CCRichAtlas.cpp \
RichControls/CCRichCache.cpp \
RichControls/CCRichCompositor.cpp \
RichControls/CCRichElement.cpp \
RichControls/CCRichOverlay.cpp \
RichControls/CCRichParser.cpp \
RichControls/CCHTMLLabel.cpp \
CocoStudio/Armature/CCArmature.cpp \
CocoStudio/Armature/CCBone.cpp \
CocoStudio/Armature/animation/CCArmatureAnimation.cpp \
CocoStudio/Armature/animation/CCProcessBase.cpp \
CocoStudio/Armature/animation/CCTween.cpp \
CocoStudio/Armature/datas/CCDatas.cpp \
CocoStudio/Armature/display/CCBatchNode.cpp \
CocoStudio/Armature/display/CCDecorativeDisplay.cpp \
CocoStudio/Armature/display/CCDisplayFactory.cpp \
CocoStudio/Armature/display/CCDisplayManager.cpp \
CocoStudio/Armature/display/CCSkin.cpp \
CocoStudio/Armature/physics/CCColliderDetector.cpp \
CocoStudio/Armature/utils/CCArmatureDataManager.cpp \
CocoStudio/Armature/utils/CCArmatureDefine.cpp \
CocoStudio/Armature/utils/CCDataReaderHelper.cpp \
CocoStudio/Armature/utils/CCSpriteFrameCacheHelper.cpp \
CocoStudio/Armature/utils/CCTransformHelp.cpp \
CocoStudio/Armature/utils/CCTweenFunction.cpp \
CocoStudio/Armature/utils/CCUtilMath.cpp \
CocoStudio/Json/DictionaryHelper.cpp	\
LocalStorage/LocalStorageAndroid.cpp 

#physics_nodes/CCPhysicsDebugNode.cpp \
#physics_nodes/CCPhysicsSprite.cpp \

LOCAL_WHOLE_STATIC_LIBRARIES += cocos2dx_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocosdenshion_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_curl_static
#LOCAL_WHOLE_STATIC_LIBRARIES += box2d_static
#LOCAL_WHOLE_STATIC_LIBRARIES += chipmunk_static

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
					$(LOCAL_PATH)/../core/include	\
					$(LOCAL_PATH)/../scripting/lua/cocos2dx_support	\
					$(LOCAL_PATH)/../scripting/lua/lua

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH) \
                           $(LOCAL_PATH)/CCBReader \
						   $(LOCAL_PATH)/AssetsManager \
                           $(LOCAL_PATH)/GUI/CCControlExtension \
                           $(LOCAL_PATH)/GUI/CCScrollView \
                           $(LOCAL_PATH)/network \
						   $(LOCAL_PATH)/dfont \
						   $(LOCAL_PATH)/RichControls \
						   $(LOCAL_PATH)/CocoStudio/Armature \
						   $(LOCAL_PATH)/CocoStudio/animation \
						   $(LOCAL_PATH)/CocoStudio/datas \
						   $(LOCAL_PATH)/CocoStudio/display \
						   $(LOCAL_PATH)/CocoStudio/physics \
						   $(LOCAL_PATH)/CocoStudio/utils \
						   $(LOCAL_PATH)/CocoStudio/Json \
                           $(LOCAL_PATH)/LocalStorage 
                    
include $(BUILD_STATIC_LIBRARY)


$(call import-module,cocos2dx)
$(call import-module,CocosDenshion/android)
$(call import-module,libcurl)
#$(call import-module,external/Box2D)
#$(call import-module,external/chipmunk)
#$(call import-module,cocos2dx/platform/third_party/android/prebuilt/libcurl)

