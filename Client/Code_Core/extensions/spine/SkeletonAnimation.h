/******************************************************************************
 * Spine Runtimes Software License
 * Version 2.1
 * 
 * Copyright (c) 2013, Esoteric Software
 * All rights reserved.
 * 
 * You are granted a perpetual, non-exclusive, non-sublicensable and
 * non-transferable license to install, execute and perform the Spine Runtimes
 * Software (the "Software") solely for internal use. Without the written
 * permission of Esoteric Software (typically granted by licensing Spine), you
 * may not (a) modify, translate, adapt or otherwise create derivative works,
 * improvements of the Software or develop new applications using the Software
 * or (b) remove, delete, alter or obscure any trademarks or any copyright,
 * trademark, patent or other intellectual property or proprietary rights
 * notices on or in the Software, including any copy thereof. Redistributions
 * in binary or source form must include this license and terms.
 * 
 * THIS SOFTWARE IS PROVIDED BY ESOTERIC SOFTWARE "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL ESOTERIC SOFTARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

#ifndef SPINE_SKELETONANIMATION_H_
#define SPINE_SKELETONANIMATION_H_

#include <spine/spine.h>
#include <spine/SkeletonRenderer.h>
#include "cocos2d.h"

USING_NS_CC;

namespace spine 
{

//typedef std::function<void(int trackIndex)> StartListener;
//typedef std::function<void(int trackIndex)> EndListener;
//typedef std::function<void(int trackIndex, int loopCount)> CompleteListener;
//typedef std::function<void(int trackIndex, spEvent* event)> EventListener;

//std::function replaced by function ptr  by liu longfei
typedef void (CCObject::*StartListener)(int trackIndex,const char* name);
typedef void (CCObject::*EndListener)(int trackIndex,const char* name);
typedef void (CCObject::*CompleteListener)(int trackIndex,const char* name,int loopCount);
typedef void (CCObject::*EventListener)(int trackIndex,const char* name, spEvent* event);

#define SpineStartEvent_selector(_SELECTOR) (StartListener)(&_SELECTOR)
#define SpineEndEvent_selector(_SELECTOR) (EndListener)(&_SELECTOR)
#define SpineCompleteEvent_selector(_SELECTOR) (CompleteListener)(&_SELECTOR)
#define SpineEvent_selector(_SELECTOR) (EventListener)(&_SELECTOR)

/** Draws an animated skeleton, providing an AnimationState for applying one or more animations and queuing animations to be
  * played later. */
class SkeletonAnimation: public SkeletonRenderer {
public:
	spAnimationState* state;

	static SkeletonAnimation* createWithData (spSkeletonData* skeletonData);
	static SkeletonAnimation* createWithFile (const char* skeletonDataFile, spAtlas* atlas, float scale = 0);
	static SkeletonAnimation* createWithFile (const char* skeletonDataFile, const char* atlasFile, float scale = 0);

	SkeletonAnimation (spSkeletonData* skeletonData);
	SkeletonAnimation (const char* skeletonDataFile, spAtlas* atlas, float scale = 0);
	SkeletonAnimation (const char* skeletonDataFile, const char* atlasFile, float scale = 0);

	virtual ~SkeletonAnimation ();

	virtual void update (float deltaTime);

	void setAnimationStateData (spAnimationStateData* stateData);
	void setMix (const char* fromAnimation, const char* toAnimation, float duration);

	spTrackEntry* setAnimation (int trackIndex, const char* name, bool loop);
	spTrackEntry* addAnimation (int trackIndex, const char* name, bool loop, float delay = 0);
	spTrackEntry* getCurrent (int trackIndex = 0);
	void clearTracks ();
	void clearTrack (int trackIndex = 0);

	CCObject*	target;
	StartListener startListener;
	EndListener endListener;
	CompleteListener completeListener;
	EventListener eventListener;
	void setStartListener (CCObject* target,spTrackEntry* entry, StartListener listener);
	void setEndListener (CCObject* target,spTrackEntry* entry, EndListener listener);
	void setCompleteListener (CCObject* target,spTrackEntry* entry, CompleteListener listener);
	void setEventListener (CCObject* target,spTrackEntry* entry, EventListener listener);

	virtual void onAnimationStateEvent (int trackIndex,const char* animationName, spEventType type,spEvent* event, int loopCount);
	virtual void onTrackEntryEvent (int trackIndex,const char* animationName,spEventType type,spEvent* event, int loopCount);
	virtual void tint(float r, float g, float b) { SkeletonRenderer::tint(r, g, b); };

protected:
	SkeletonAnimation ();

private:
	typedef SkeletonRenderer super;
	bool ownsAnimationStateData;

	void initialize ();
};

}

#endif /* SPINE_SKELETONANIMATION_H_ */
