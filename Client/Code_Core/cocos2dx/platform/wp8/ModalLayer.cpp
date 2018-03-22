/****************************************************************************
Copyright (c) 2013 cocos2d-x.org
Copyright (c) Microsoft Open Technologies, Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
#include "ModalLayer.h"

using namespace cocos2d;

static void stringAutoReturn(const std::string& inString, std::string& outString, int width, int& lines)
{
	std::string::size_type start;
	outString = "";
	outString.reserve(inString.size() + 64);

	width *= 2;
	int count = 0;
	for (start = 0; start < inString.size(); ++start)
	{

		unsigned char cha = inString[start];
		unsigned char andres1 = cha & 0x80;
		if (andres1 == 0)
		{
			count++;
			outString.push_back(cha);
			if (count >= width)
			{
				outString.push_back('\n');
				count = 0;
				lines++;
			}
		}
		else
		{
			unsigned char andres2 = cha & 0x40;
			if (andres2 != 0)
			{
				count += 2;
				if (count > width)
				{
					outString.push_back('\n');
					count = 2;
					lines++;
				}
			}
			outString.push_back(cha);
		}
	}
}

ModalLayer::~ModalLayer()
{
	CC_SAFE_RELEASE(m_frame);
}

bool ModalLayer::init()
{
	m_pCallback = NULL;

    if ( !CCLayer::init() )
    {
        return false;
    }
    
    CCDirector* pDirector = CCDirector::sharedDirector();
	CCSize visibleSize = pDirector->getVisibleSize();
    CCPoint origin = pDirector->getVisibleOrigin();

    pDirector->getTouchDispatcher()->addTargetedDelegate(this, kCCMenuHandlerPriority, true);
    
	m_frame = CCLayerColor::create(ccc4(0, 0, 0, 255 *.75));
	CC_SAFE_RETAIN(m_frame);

    m_frame->setPosition(ccp(0, 0));
    this->addChild(m_frame);

	CCMenuItemFont *pCloseItem = CCMenuItemFont::create("OK", this, menu_selector(ModalLayer::menuCloseCallback) );
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    m_frame->addChild(pMenu);
    
    return true;
}

void ModalLayer::setMessage(const char* pszMsg)
{
    CCDirector* pDirector = CCDirector::sharedDirector();
	CCSize visibleSize = pDirector->getVisibleSize();
    CCPoint origin = pDirector->getVisibleOrigin();

	std::string inStr(pszMsg);
	std::string outStr;
	int iLines = 1;
	stringAutoReturn(inStr, outStr, visibleSize.width/24-2, iLines);

	CCLabelTTF *pLabel = CCLabelTTF::create(outStr.c_str(), "Arial", 24, CCSizeMake(0, 0), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop);
   pLabel->setPosition(ccp(origin.x + visibleSize.width/2,
                            origin.y + visibleSize.height - pLabel->getContentSize().height-20));

 
    // add the label as a child to this layer
    m_frame->addChild(pLabel, 1);
}





bool ModalLayer::ccTouchBegan(CCTouch* touch, CCEvent* event) {
    // can not touch on back layers
    return true;
}

void ModalLayer::menuCloseCallback(CCObject* pSender)
{
    this->removeFromParentAndCleanup(true);
    
    CCDirector* pDirector = CCDirector::sharedDirector();
    pDirector->getTouchDispatcher()->removeDelegate(this);

	if (m_pCallback)
	{
		m_pCallback(m_iTag, 0, m_pCtx);
	}
}

void ModalLayer::setChoiceCallback(MessageBoxCallback pCallback, int tag, void* ctx)
{
	m_pCallback = pCallback;
	m_iTag = tag;
	m_pCtx = ctx;
}
