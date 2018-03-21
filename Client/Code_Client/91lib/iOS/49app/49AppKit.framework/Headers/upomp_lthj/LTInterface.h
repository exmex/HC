//
//  LTInterface.h
//  UnionPayLib
//
//  Created by huajian on 11-7-18.
//  Copyright 2011 联通华健网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol LTInterfaceDelegate<NSObject>
/*交易插件退出回调方法，需要商户客户端实现
 *参数：
	strResult：交易结果，若为空则用户未进行交易。
 返回值：无
 */
- (void) returnWithResult:(NSString *)strResult;

@end


@interface LTInterface:NSObject {

}


/*获得插件主页，调用者负责释放
 *参数：nType:		生产测试  0 生产 1 测试
 strOrder:		调用报文字符串
 id<LTInterfaceDelegate>：	支付插件代理，插件退出时会将交易结果通知商户客户端。
 返回值：返回插件的ViewController实例，由调用者负责释放
 */
+ (UIViewController *) getHomeViewControllerWithType:(NSInteger) nType
                                            strOrder:(NSString *)strOrder
                                         andDelegate:(id<LTInterfaceDelegate>)delegate;
@end



