
#include "cocos2d.h"

//
#include "CCScrollView.h"
#include "CCReViScrollViewFacade.h"

	
//



cocos2d::extension::CCReViScrollViewFacade::CCReViScrollViewFacade( CCScrollView* pView )
	:m_pScrollView(pView),m_iFixedViewItemsMaxNum(Macro_FixedViewItemsMaxNum)
	,m_iCurStartIdx(0),m_arrayItems(NULL)/*,m_arrayItemViews(NULL)*/
	,m_iVirtualPartRectIdx(0),m_iRealLoadedStartIdx(0),m_iRealLoadedEndIdx(0)
	,m_pOtherDelegate(NULL)
{
	m_ptCurStart.x = m_ptCurStart.y = 0.f;
	m_pScrollView->setDelegate(this);
	m_arrayItemViews.clear();
}

cocos2d::extension::CCReViScrollViewFacade::~CCReViScrollViewFacade()
{
	if (m_arrayItems)
		delete m_arrayItems;
// 	if (m_arrayItemViews)
// 		delete m_arrayItemViews;
	ArrayItemViewVec::iterator itr = m_arrayItemViews.begin();
	while(itr!= m_arrayItemViews.end())
	{
		delete (*itr);
		itr++;
	}
    ArrayItemViewVec temp;
	m_arrayItemViews.swap(temp);
	//
	m_pScrollView->setDelegate(NULL);
	m_pScrollView = NULL;
	m_pOtherDelegate = NULL;
}

bool cocos2d::extension::CCReViScrollViewFacade::init( unsigned int iNum /*= Macro_FixedViewItemsMaxNum*/, 
	unsigned int iSize /*= Macro_FixedViewItemsMaxNum*/, CCScrollViewDelegate* pOtherDelegate /*= NULL*/,unsigned int lineNum /* = 1 */ )
{
	m_iFixedViewItemsMaxNum = iNum;

	mLineNum = lineNum;
	//
	m_arrayItems = new CCArray(iSize);
	//
	if (iSize >= iNum*Macro_FixedItemViewsMultiply)
	{
		//m_arrayItemViews = new CCArray(iNum*Macro_FixedItemViewsMultiply);
		m_arrayItemViews.reserve(iNum*Macro_FixedItemViewsMultiply);
	}
	else
	{
		//m_arrayItemViews = new CCArray(iSize);
		m_arrayItemViews.reserve(iSize);
	}
	//
	m_pOtherDelegate = pOtherDelegate;
	//
	return true;
}

void cocos2d::extension::CCReViScrollViewFacade::scrollViewDidScroll( CCScrollView* view )
{
	if (m_pOtherDelegate)
		m_pOtherDelegate->scrollViewDidScroll(view);
	//m_pOtherDelegate先响应
	//
	if (m_arrayItems->count() <= m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply)
		return;
	if (m_arrayItemViews.size() < 1)
		return;
	/*
		ScrollView实现时已强制Container及ItemViews锚点(0.0f, 0.0f)
	*/
	/*const */CCPoint/*&*/ pos = view->getContainer()->getPosition();
	/*
		下面假设受控的itemViews都是等尺寸的，如果要支持不等尺寸改遍历计算相关数值
	*/
	CCReViSvItemNodeFacade* pOneItemView = m_arrayItemViews[0];
	if (pOneItemView == NULL || pOneItemView->m_pItemNode == NULL)
		return;
	//
	if (m_pScrollView->getDirection() == kCCScrollViewDirectionHorizontal)
	{
		const float theDeltX = pOneItemView->m_pItemNode->getContentSize().width * m_iFixedViewItemsMaxNum;
		const float realDeltX = pos.x - m_ptCurStart.x;
		//
		if (realDeltX > 0.f && realDeltX > theDeltX)
		{
			//
			pos.x = pos.x - (realDeltX-theDeltX);
			m_pScrollView->getContainer()->setPosition(pos);
			//向左滑动了，需要加载右边的
			loadDownOrLeftAndRefresh();
		}
		else if (realDeltX < 0.f && (0.f-realDeltX) > theDeltX)
		{
			//
			pos.x = pos.x + (-realDeltX-theDeltX);
			m_pScrollView->getContainer()->setPosition(pos);
			//向右滑动了，需要加载左边的
			loadUpOrRightAndRefresh();
		}
		//
	}
	else if (m_pScrollView->getDirection() == kCCScrollViewDirectionVertical)
	{
		const float theDeltY = pOneItemView->m_pItemNode->getContentSize().height * m_iFixedViewItemsMaxNum/mLineNum;
		const float realDeltY = pos.y - m_ptCurStart.y;
		//
		if (realDeltY > 0.f && realDeltY > theDeltY && realDeltY < 2*theDeltY)
		{
			//修正滚动带来的不规则性
			//pos.y = int(pos.y/theDeltY)*theDeltY;
			pos.y = pos.y - (realDeltY-theDeltY);
			m_pScrollView->getContainer()->setPosition(pos);
			//向上滑动了，需要加载下边的
			loadDownOrLeftAndRefresh();
		}
		else if (realDeltY < 0.f && (0.f-realDeltY) > theDeltY && (0.f-realDeltY) < 2*theDeltY)
		{
			//修正滚动带来的不规则性
			//pos.y = int(pos.y/theDeltY)*theDeltY;
			pos.y = pos.y + (-realDeltY-theDeltY);
			m_pScrollView->getContainer()->setPosition(pos);
			//向下滑动了，需要加载上边的
			loadUpOrRightAndRefresh();
		}
		//
	}
}

void cocos2d::extension::CCReViScrollViewFacade::addItem( CCReViSvItemData* item, CCReViSvItemNodeFacade* node /*= NULL*/ )
{
	m_arrayItems->addObject(item);
	if (node && node->m_pItemNode && (m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply > m_arrayItemViews.size()))
	{
		m_arrayItemViews.push_back(node);

		m_pScrollView->getContainer()->addChild(node->m_pItemNode);

		//调整scrollview的size、offset交由外部逻辑自行处理（必须）
		//node的位置初始setDynamicItemsStartPosition设置，滑动时需要挪了动态计算
		//node->m_pItemNode->setPosition(item->m_ptPosition);
	}
}

void cocos2d::extension::CCReViScrollViewFacade::insertItemAtIdx( CCReViSvItemData* item, int idx, CCReViSvItemNodeFacade* node /*= NULL*/ )
{

}

void cocos2d::extension::CCReViScrollViewFacade::removeItem( CCReViSvItemData* item )
{

}

void cocos2d::extension::CCReViScrollViewFacade::removeItemAtIdx( int idx )
{

}

void cocos2d::extension::CCReViScrollViewFacade::clearAllItems()
{
	m_iCurStartIdx = 0;
	m_ptCurStart.x = m_ptCurStart.y = 0;
	m_iVirtualPartRectIdx = 0;
	{
		CCObject* pItem = NULL;
		CCARRAY_FOREACH(m_arrayItems, pItem)
		{
			CCReViSvItemData* pData = (CCReViSvItemData*)pItem;
			delete pData;
		}
	}
	m_arrayItems->data->num = 0;
	/*
		没有用CCArray那一套Release释放
		new CCObject m_uReference == 1
		CCArray addObject m_uReference++
		removeObject m_uReference--
		正确的使用  用removeallobject
		然后在所有item new的地方设置autorelease

	*/
// 	{
// 		//
// 		CCObject* pItem = NULL;
// 		CCARRAY_FOREACH(m_arrayItemViews, pItem)
// 		{
// 			CCReViSvItemNodeFacade* pView = (CCReViSvItemNodeFacade*)pItem;
// 
// 			//m_pScrollView->removeChild(pView->m_pItemNode);//这里省了，因为外部使用者会removeAllChildren
// 
// 			delete pView;
// 		}
// 	}
// 	m_arrayItemViews->data->num = 0;
	ArrayItemViewVec::iterator itr = m_arrayItemViews.begin();
	while(itr!= m_arrayItemViews.end())
	{
		delete (*itr);
		itr++;
	}
	ArrayItemViewVec list;
	m_arrayItemViews.swap(list);
}



void cocos2d::extension::CCReViScrollViewFacade::refreshDynamicScrollView(){
	//根据记录的StartIdex重置位置和刷新content
	setDynamicItemsStartPosition(m_iCurStartIdx);
}

void cocos2d::extension::CCReViScrollViewFacade::setDynamicItemsStartPosition( unsigned int idx )
{
	if (idx < 0 || idx >= m_arrayItems->count())
	{
		return;
	}
	//
	m_iCurStartIdx = idx;
	//
	m_ptCurStart = m_pScrollView->getContainer()->getPosition();//这个同idx在外部已规划好
	//
	//确定了m_iCurStartIdx&m_ptCurStart就可以对所有加入的受控itemviews进行排列了
	//初始把m_iCurStartIdx对应到中间的那块part，下面在idx上下找到合理的上下限
	m_iVirtualPartRectIdx = Macro_FixedItemViewsMultiply/2;
	//
	unsigned int iD = idx;
	unsigned int iU = idx;
	unsigned int iCount = 1;
	for (unsigned int k = 1; k < m_iFixedViewItemsMaxNum; ++k)
	{
		if (iD < (m_arrayItems->count()-1))
		{
			++iD;
			++iCount;
		}
		else
		{
			break;
		}
	}
	//
	while (iCount < m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply)
	{
		bool b1 = false,b2 = false;
		if (iD < (m_arrayItems->count()-1))
		{
			++iD;
			++iCount;
		}
		else
			b1 = true;
		//
		if (iCount >= m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply)
			break;
		if (iU > 0)
		{
			--iU;
			++iCount;
		}
		else
			b2 = true;
		//
		if (iCount >= m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply)
			break;
		//
		if (b1 && b2)
			break;
	}
	//
	CCAssert((iD-iU+1)<=m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply, "CCReViScrollViewFacade::setDynamicItemsStartPosition");
	//
	for (unsigned int i = 0,j = iU; j <= iD && i < m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply; ++i,++j)
	{
		CCReViSvItemData* pItem = (CCReViSvItemData*)m_arrayItems->objectAtIndex(j);
		CCReViSvItemNodeFacade* pItemView = (CCReViSvItemNodeFacade*)m_arrayItemViews[i];
		pItem->m_iItemNodeIdx = i;
		//
		pItemView->m_pItemNode->setPosition(pItem->m_ptPosition);
		//
		pItemView->refreshItemView(pItem);
	}
	m_iRealLoadedStartIdx = iU;
	m_iRealLoadedEndIdx = iD;
	//
}

cocos2d::extension::CCReViSvItemNodeFacade* cocos2d::extension::CCReViScrollViewFacade::findItemNodeByItemData( CCReViSvItemData* pItem )
{
	if (pItem && pItem->m_iItemNodeIdx >= 0 && 
		pItem->m_iItemNodeIdx < m_arrayItemViews.size())
	{
		return m_arrayItemViews[pItem->m_iItemNodeIdx];
	}
	return NULL;
}

cocos2d::extension::CCReViSvItemNodeFacade* cocos2d::extension::CCReViScrollViewFacade::findItemNodeByIndex( unsigned int index )
{
	if (index < m_arrayItemViews.size())
	{
		return m_arrayItemViews[index];
	}
	return NULL;
}



void cocos2d::extension::CCReViScrollViewFacade::loadDownOrLeftAndRefresh()
{
	m_ptCurStart = m_pScrollView->getContainer()->getPosition();
	//
	int iTempStartIdx = m_iCurStartIdx - m_iFixedViewItemsMaxNum;
	if (iTempStartIdx < 0)
		return;
	if (m_iCurStartIdx > (m_arrayItems->count() - (Macro_FixedItemViewsMultiply/2)*m_iFixedViewItemsMaxNum))
	{
		m_iCurStartIdx = iTempStartIdx;
		return;
	}
	int iTempVirtualPartIdx = m_iVirtualPartRectIdx + 1;
	if (iTempVirtualPartIdx >= Macro_FixedItemViewsMultiply)
		iTempVirtualPartIdx = 0;
	//
	int iU = m_iRealLoadedStartIdx;
	int iD = m_iRealLoadedEndIdx;
	for (unsigned int i = 0; i < m_iFixedViewItemsMaxNum; ++i)
	{
		if (iU > 0)
		{
			--iU;
			--iD;
		}
	}
	//
	int iTmp = m_iRealLoadedStartIdx - iU;
	for (int j = 0; j < iTmp; ++j)
	{
		CCReViSvItemData* pItem = (CCReViSvItemData*)m_arrayItems->objectAtIndex(m_iRealLoadedEndIdx-j);
		if (pItem->m_iItemNodeIdx > m_arrayItemViews.size())
		{
			CCAssert(false, "CCReViScrollViewFacade::loadDownOrLeftAndRefresh");
			break;
		}
		CCReViSvItemNodeFacade* pItemView = m_arrayItemViews[pItem->m_iItemNodeIdx];
		CCReViSvItemData* pItem1 = (CCReViSvItemData*)m_arrayItems->objectAtIndex(m_iRealLoadedStartIdx-j-1);
		pItemView->m_pItemNode->setPosition(pItem1->m_ptPosition);
		pItemView->refreshItemView(pItem1);
		pItem1->m_iItemNodeIdx = pItem->m_iItemNodeIdx;
		pItem->m_iItemNodeIdx = -1;
		//
	}
	m_iRealLoadedStartIdx = iU;
	m_iRealLoadedEndIdx = iD;
	//
	m_iCurStartIdx = iTempStartIdx;
	//内部变动了，再调一次setPosition
	m_pScrollView->getContainer()->setPosition(m_ptCurStart);
}

void cocos2d::extension::CCReViScrollViewFacade::loadUpOrRightAndRefresh()
{
	m_ptCurStart = m_pScrollView->getContainer()->getPosition();
	//
	unsigned int iTempStartIdx = m_iCurStartIdx + m_iFixedViewItemsMaxNum;
	if (iTempStartIdx >= m_arrayItems->count())
		return;
	if (m_iCurStartIdx < (Macro_FixedItemViewsMultiply/2)*m_iFixedViewItemsMaxNum)
	{
		m_iCurStartIdx = iTempStartIdx;
		return;
	}
	int iTempVirtualPartIdx = m_iVirtualPartRectIdx - 1;
	if (iTempVirtualPartIdx < 0)
		iTempVirtualPartIdx = Macro_FixedItemViewsMultiply - 1;
	//
	int iU = m_iRealLoadedStartIdx;
	int iD = m_iRealLoadedEndIdx;
	for (unsigned int i = 0; i < m_iFixedViewItemsMaxNum; ++i)
	{
		if (iD < int(m_arrayItems->count()-1))
		{
			++iD;
			++iU;
		}
	}
	//
	int iTmp = iD - m_iRealLoadedEndIdx;
	for (int j = 0; j < iTmp; ++j)
	{
		CCReViSvItemData* pItem = (CCReViSvItemData*)m_arrayItems->objectAtIndex(m_iRealLoadedStartIdx+j);
		if (pItem->m_iItemNodeIdx > m_arrayItemViews.size())
		{
			CCAssert(false, "CCReViScrollViewFacade::loadDownOrLeftAndRefresh");
			break;
		}
		CCReViSvItemNodeFacade* pItemView = m_arrayItemViews[pItem->m_iItemNodeIdx];
		CCReViSvItemData* pItem1 = (CCReViSvItemData*)m_arrayItems->objectAtIndex(m_iRealLoadedEndIdx+j+1);
		pItemView->m_pItemNode->setPosition(pItem1->m_ptPosition);
		pItemView->refreshItemView(pItem1);
		pItem1->m_iItemNodeIdx = pItem->m_iItemNodeIdx;
		pItem->m_iItemNodeIdx = -1;
		//
	}
	m_iRealLoadedStartIdx = iU;
	m_iRealLoadedEndIdx = iD;
	//
	m_iCurStartIdx = iTempStartIdx;
	//内部变动了，再调一次setPosition
	m_pScrollView->getContainer()->setPosition(m_ptCurStart);
}

