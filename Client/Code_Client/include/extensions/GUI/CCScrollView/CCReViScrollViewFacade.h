
/*
	CCReuseVisibleScrollViewFacade
	对于需要加载大量子items的ScrollView，用固定少量的可见items根据ScrollView滚动，动态复用Items模拟加载了大量items
	因为与业务逻辑相关性强，只提供现有一个ScrollView实例的包装以完成功能，而非直接继承ScrollView
	只支持单方向kCCScrollViewDirectionHorizontal、kCCScrollViewDirectionVertical
*/

#ifndef __CCREVISCROLLVIEWFACADE_H__
#define __CCREVISCROLLVIEWFACADE_H__

#include "cocos2d.h"
#include "ExtensionMacros.h"

	//class cocos2d::CCPoint;
	//class cocos2d::CCObject;
	//class cocos2d::CCArray;
	//class cocos2d::CCNode;

NS_CC_EXT_BEGIN
	class CCScrollView;
	class CCScrollViewDelegate;
	class CCReViScrollViewFacade;
	//
	class CCReViSvItemData : public CCObject	//Model
	{
		friend class CCReViScrollViewFacade;
	public:
		CCReViSvItemData()
			:m_iIdx(0),m_iItemNodeIdx(-1)
		{
			m_ptPosition.x = m_ptPosition.y = 0.f;
		}
	public:
		CCPoint		m_ptPosition;
		//CCSize		m_szContentSize;
		unsigned int	m_iIdx;	//for debug
	private:
		unsigned int	m_iItemNodeIdx;
	};
	//
	class CCReViSvItemNodeFacade/* : virtual public CCObject*/	//View
	{
		friend class CCReViScrollViewFacade;
	public:
		virtual ~CCReViSvItemNodeFacade(){};
		virtual void initItemView() = 0;
		virtual void refreshItemView(CCReViSvItemData* pItem) = 0;
	protected:
		CCNode*		m_pItemNode;
	};
	//
#define Macro_FixedViewItemsMaxNum 4
#define Macro_FixedItemViewsMultiply 3
	//
	class CCReViScrollViewFacade : CCScrollViewDelegate //Control
	{
	public:
		CCReViScrollViewFacade(CCScrollView* pView);
		virtual ~CCReViScrollViewFacade();

		/*
			iNum:受控的itemviews的动态区域，等分为Macro_FixedItemViewsMultiply部分，每部分iNum个itemviews
			iSize:初始化的时候，预估下可能有多少受控itemviews
		*/
		bool	init(unsigned int iNum = Macro_FixedViewItemsMaxNum, 
			unsigned int iSize = Macro_FixedViewItemsMaxNum, CCScrollViewDelegate* pOtherDelegate = NULL,unsigned int lineNum = 1);

		unsigned int getMaxDynamicControledItemViewsNum()
		{
			return m_iFixedViewItemsMaxNum*Macro_FixedItemViewsMultiply;
		}

	//
	public:
		virtual void scrollViewDidScroll(CCScrollView* view);
		virtual void scrollViewDidZoom(CCScrollView* view)
		{
			if (m_pOtherDelegate)
				m_pOtherDelegate->scrollViewDidZoom(view);
			//不处理，不是说缩小自动加载更多items，放大自动释放过多items
		}
		virtual void scrollViewDidDeaccelerateScrolling(CCScrollView* view, CCPoint initSpeed)
		{
			if (m_pOtherDelegate)
				m_pOtherDelegate->scrollViewDidDeaccelerateScrolling(view, initSpeed);
		}
		virtual void scrollViewDidDeaccelerateStop(CCScrollView* view, CCPoint initSpeed)
		{
			if (m_pOtherDelegate)
				m_pOtherDelegate->scrollViewDidDeaccelerateStop(view, initSpeed);
		}

	//
	public:
		void	addItem(CCReViSvItemData* item, CCReViSvItemNodeFacade* node = NULL);
		void	insertItemAtIdx(CCReViSvItemData* item, int idx, CCReViSvItemNodeFacade* node = NULL);
		void	removeItem(CCReViSvItemData* item);
		void	removeItemAtIdx(int idx);
		void	clearAllItems();

		//add by zhenhui
		//Hint:
		//1.)用于单纯地刷新scroolview中的数据，而不需要重新rebuildAll,且保持当前位置，如商店购买物品后刷新scrollView等。
		//2.)不适用与点击某个content后，需要删除该content，这种情况需要rebuild后重新getContainer()->setPosition()，尽量避免setContentOffset，触发scrollViewDidScroll，导致错位
		void	refreshDynamicScrollView();
		//end 
		/*
			动态调整位置复用的items的起始位置，这部分items必须是连续排列的，它们外部可以有其他items不受本Facade影响
			addItem内部未自动排列位置，全部addItem完毕后，要求调用者自行调整ScrollView的contentsize、offset（必须）
			再调用本方法，动态调整位置会在横向或纵向对受控items进行自动排列
			当所有受控items添加完毕，要求调用者指定哪一个位置&索引的受控item作为锚点(0.0f, 0.0f)参考（必须）
			即，假设ScrollView没有其他items，指定哪一个受控item初始显示在ViewRect的左上角
		*/
		void	setDynamicItemsStartPosition(unsigned int idx);
		unsigned int getStartPosition() { return m_iCurStartIdx; };
		/*
			如果ItemData对应的ItemNode当前不住realloaded
		*/
		CCReViSvItemNodeFacade* findItemNodeByItemData(CCReViSvItemData* pItem);

		CCReViSvItemNodeFacade* findItemNodeByIndex(unsigned int index);
	//
	private:
		void	loadDownOrLeftAndRefresh();
		void	loadUpOrRightAndRefresh();

	//
	private:
		CCScrollView*	m_pScrollView;
		/*
			
		*/
		CCScrollViewDelegate*	m_pOtherDelegate;
		/*
			ScrollView可见区域内合理Items个数，内部将创建Macro_FixedItemViewsMultiply倍个数Items以实现动态复用模拟大量Items
		*/
		unsigned int	m_iFixedViewItemsMaxNum;
		/*
		每行item的个数
		*/
		unsigned int	mLineNum;
		/*
		*/
		CCArray*		m_arrayItems;
		/*
			ScrollView可见区域最上或最左当前正显示的Item在m_arrayItems中的索引
		*/
		unsigned int	m_iCurStartIdx;
		/*
		*/
		//CCArray*		m_arrayItemViews;
		typedef std::vector<CCReViSvItemNodeFacade*> ArrayItemViewVec;
		ArrayItemViewVec m_arrayItemViews;
		/*
		*/
		CCPoint			m_ptCurStart;
		/*
			受控的itemviews的动态区域，等分为Macro_FixedItemViewsMultiply部分，每部分m_iFixedViewItemsMaxNum个itemviews
			取值[0,(Macro_FixedItemViewsMultiply-1)]，标示当前对应于m_iCurStartIdx的部分
		*/
		unsigned int	m_iVirtualPartRectIdx;
		/*
		*/
		unsigned int	m_iRealLoadedStartIdx;
		unsigned int	m_iRealLoadedEndIdx;
	};


NS_CC_EXT_END

#endif//__CCREVISCROLLVIEWFACADE_H__


