#include "GameAnimation.h"
#include "SpineContainer.h"
#include "LegendAnimation.h"

GameAnimation::GameAnimation(AnimationTye aniType)
: mAniType(aniType)
{
}


GameAnimation::~GameAnimation()
{
}

GameAnimation* GameAnimation::create(const char* resource, double scale /* = 1.0 */, AnimationTye aniType /* = Type_LegendAnimation */)
{
	return NULL;
}