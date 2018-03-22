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

#include <spine/SkeletonAnimation.h>
#include <spine/spine-cocos2dx.h>
#include <spine/extension.h>
#include <algorithm>

USING_NS_CC;
using std::min;
using std::max;
using std::vector;

namespace spine 
{

void animationCallback (spAnimationState* state, int trackIndex,const char* animationName, spEventType type, spEvent* event, int loopCount) 
{
	((SkeletonAnimation*)state->rendererObject)->onAnimationStateEvent(trackIndex,animationName, type, event, loopCount);
}

void trackEntryCallback (spAnimationState* state, int trackIndex,const char* animationName, spEventType type, spEvent* event, int loopCount) 
{
	((SkeletonAnimation*)state->rendererObject)->onTrackEntryEvent(trackIndex,animationName, type, event, loopCount);
}

typedef struct _TrackEntryListeners 
{
	_TrackEntryListeners()
	{
		startListener = NULL;
		endListener = NULL;
		completeListener = NULL;
		eventListener = NULL;
		target = NULL;
	}
	CCObject*	target;
	StartListener startListener;
	EndListener endListener;
	CompleteListener completeListener;
	EventListener eventListener;
} 
_TrackEntryListeners;

static _TrackEntryListeners* getListeners (spTrackEntry* entry) {
	if (!entry->rendererObject) {
		entry->rendererObject = NEW(spine::_TrackEntryListeners);
		entry->listener = trackEntryCallback;
	}
	return (_TrackEntryListeners*)entry->rendererObject;
}

void disposeTrackEntry (spTrackEntry* entry) {
	if (entry->rendererObject) FREE(entry->rendererObject);
	_spTrackEntry_dispose(entry);
}

//

SkeletonAnimation* SkeletonAnimation::createWithData (spSkeletonData* skeletonData) {
	SkeletonAnimation* node = new SkeletonAnimation(skeletonData);
	node->autorelease();
	return node;
}

SkeletonAnimation* SkeletonAnimation::createWithFile (const char* skeletonDataFile, spAtlas* atlas, float scale) {
	SkeletonAnimation* node = new SkeletonAnimation(skeletonDataFile, atlas, scale);
	node->autorelease();
	return node;
}

SkeletonAnimation* SkeletonAnimation::createWithFile (const char* skeletonDataFile, const char* atlasFile, float scale) {
	SkeletonAnimation* node = new SkeletonAnimation(skeletonDataFile, atlasFile, scale);
	node->autorelease();
	return node;
}

void SkeletonAnimation::initialize () {
	ownsAnimationStateData = true;
	state = spAnimationState_create(spAnimationStateData_create(skeleton->data));
	state->rendererObject = this;
	state->listener = animationCallback;

	_spAnimationState* stateInternal = (_spAnimationState*)state;
	stateInternal->disposeTrackEntry = disposeTrackEntry;

	target = NULL;
	startListener = NULL;
	endListener = NULL;
	completeListener = NULL;
	eventListener = NULL;
}

SkeletonAnimation::SkeletonAnimation (spSkeletonData *skeletonData)
		: SkeletonRenderer(skeletonData) {
	initialize();	
}

SkeletonAnimation::SkeletonAnimation (const char* skeletonDataFile, spAtlas* atlas, float scale)
		: SkeletonRenderer(skeletonDataFile, atlas, scale) {
	initialize();
}

SkeletonAnimation::SkeletonAnimation (const char* skeletonDataFile, const char* atlasFile, float scale)
		: SkeletonRenderer(skeletonDataFile, atlasFile, scale) {
	initialize();
}

SkeletonAnimation::~SkeletonAnimation () {
	if (ownsAnimationStateData) spAnimationStateData_dispose(state->data);
	spAnimationState_dispose(state);
}

void SkeletonAnimation::update (float deltaTime) {
	super::update(deltaTime);

	deltaTime *= timeScale;
	spAnimationState_update(state, deltaTime);
	spAnimationState_apply(state, skeleton);
	spSkeleton_updateWorldTransform(skeleton);
}

void SkeletonAnimation::setAnimationStateData (spAnimationStateData* stateData) {
	CCAssert(stateData, "stateData cannot be null.");

	if (ownsAnimationStateData) spAnimationStateData_dispose(state->data);
	spAnimationState_dispose(state);

	ownsAnimationStateData = false;
	state = spAnimationState_create(stateData);
	state->rendererObject = this;
	state->listener = animationCallback;
}

void SkeletonAnimation::setMix (const char* fromAnimation, const char* toAnimation, float duration) {
	spAnimationStateData_setMixByName(state->data, fromAnimation, toAnimation, duration);
}

spTrackEntry* SkeletonAnimation::setAnimation (int trackIndex, const char* name, bool loop) {
	spAnimation* animation = spSkeletonData_findAnimation(skeleton->data, name);
	if (!animation) {
		CCLog("Spine: Animation not found: %s", name);
		return 0;
	}
	return spAnimationState_setAnimation(state, trackIndex, animation, loop);
}

spTrackEntry* SkeletonAnimation::addAnimation (int trackIndex, const char* name, bool loop, float delay) {
	spAnimation* animation = spSkeletonData_findAnimation(skeleton->data, name);
	if (!animation) {
		CCLog("Spine: Animation not found: %s", name);
		return 0;
	}
	return spAnimationState_addAnimation(state, trackIndex, animation, loop, delay);
}

spTrackEntry* SkeletonAnimation::getCurrent (int trackIndex) { 
	return spAnimationState_getCurrent(state, trackIndex);
}

void SkeletonAnimation::clearTracks () {
	spAnimationState_clearTracks(state);
}

void SkeletonAnimation::clearTrack (int trackIndex) {
	spAnimationState_clearTrack(state, trackIndex);
}

void SkeletonAnimation::onAnimationStateEvent (int trackIndex, const char* animationName,spEventType type, spEvent* event, int loopCount) 
{
	switch (type)
	{
	case SP_ANIMATION_START:
		//if (startListener) startListener(trackIndex);
		if (target&&startListener) (target->*startListener)(trackIndex,animationName);
		break;
	case SP_ANIMATION_END:
		if (target&&endListener) (target->*endListener)(trackIndex,animationName);
		//if (endListener) endListener(trackIndex);
		break;
	case SP_ANIMATION_COMPLETE:
		if (target&&completeListener) (target->*completeListener)(trackIndex,animationName,loopCount);
		//if (completeListener) completeListener(trackIndex, loopCount);
		break;
	case SP_ANIMATION_EVENT:
		if (target&&eventListener) (target->*eventListener)(trackIndex,animationName,event);
		//if (eventListener) eventListener(trackIndex, event);
		break;
	}
}

void SkeletonAnimation::onTrackEntryEvent (int trackIndex,const char* animationName, spEventType type, spEvent* event, int loopCount) {
	spTrackEntry* entry = spAnimationState_getCurrent(state, trackIndex);
	if (entry&&!entry->rendererObject) return;
	_TrackEntryListeners* listeners = (_TrackEntryListeners*)entry->rendererObject;

	switch (type)
	{
	case SP_ANIMATION_START:
		if (listeners->startListener && listeners->target)
		{
			(listeners->target->*(listeners->startListener))(trackIndex,animationName);
		}
		//if (listeners->startListener) listeners->startListener(trackIndex);
		break;
	case SP_ANIMATION_END:
		if (listeners->endListener && listeners->target)
		{
			(listeners->target->*(listeners->endListener))(trackIndex,animationName);
		}
		//if (listeners->endListener) listeners->endListener(trackIndex);
		break;
	case SP_ANIMATION_COMPLETE:
		if (listeners->completeListener && listeners->target)
		{
			(listeners->target->*(listeners->completeListener))(trackIndex,animationName,loopCount);
		}
		//if (listeners->completeListener) listeners->completeListener(trackIndex, loopCount);
		break;
	case SP_ANIMATION_EVENT:
		if (listeners->eventListener && listeners->target)
		{
			(listeners->target->*(listeners->eventListener))(trackIndex,animationName,event);
		}
		//if (listeners->eventListener) listeners->eventListener(trackIndex, event);
		break;
	}
}

void SkeletonAnimation::setStartListener (CCObject* target,spTrackEntry* entry, StartListener listener) 
{
	getListeners(entry)->target = target;
	getListeners(entry)->startListener = listener;
}

void SkeletonAnimation::setEndListener (CCObject* target,spTrackEntry* entry, EndListener listener) 
{
	getListeners(entry)->target = target;
	getListeners(entry)->endListener = listener;
}

void SkeletonAnimation::setCompleteListener (CCObject* target,spTrackEntry* entry, CompleteListener listener)
{
	getListeners(entry)->target = target;
	getListeners(entry)->completeListener = listener;
}

void SkeletonAnimation::setEventListener (CCObject* target,spTrackEntry* entry, spine::EventListener listener)
{
	getListeners(entry)->target = target;
	getListeners(entry)->eventListener = listener;
}

}
