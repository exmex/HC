//
//  PPAppPlatformKitConfig.h
//  PPAppPlatformKit
//
//  Created by 张熙文 on 1/11/13.
//  Copyright (c) 2013 张熙文. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Public -
typedef struct MsgGameServerResponse
{
    uint32_t len;
    uint32_t command;
    uint32_t status;                //0为成功，其他为失败
}MSG_GAME_SERVER_RESPONSE;


typedef struct MsgGameServer{
    uint32_t		len;                //21
    uint32_t		commmand;           //[0xAA000021]
    char            token_key[16];
}MSG_GAME_SERVER;

typedef struct MsgGameServer_Str{
    uint32_t		len_str;                //41
    uint32_t		commmand_str;           //[0xAA000022]
    char            token_key_str[33];
}MSG_GAME_SERVER_STR;
/**
 *  SDK发送给游戏客户端通知
 */
/**
 * @brief PPWeb页面关闭回调参数
 */
typedef enum{
    /**
     * 返回充值页面
     */
	PPWebViewCodeRecharge = 1,
    /**
     * 返回充值并且兑换页面
     */
    PPWebViewCodeRechargeAndExchange = 2,
    /**
     *  WEB其他页面关闭
     */
    PPWebViewCodeOther = 3,
    
}PPWebViewCode;


/**
 * @brief 错误范围，用来标识错误是接口返回的还是SDK返回的。
 */
typedef enum{
    /**
     * 关闭接口为登录页面
     */
	PPLoginViewPageCode	= 1,
    /**
     * 关闭接口为注册
     */
    PPRegisterViewPageCode = 2,
    
    /**
     *  其他页面退出
     */
    PPOtherViewPageCode = 3,
    
}PPPageCode;


/**
 * @brief 错误范围，用来标识错误是接口返回的还是SDK返回的。
 */
typedef enum{
    /**
     * 购买成功
     */
	PPPayResultCodeSucceed	= 0,
    /**
     * 禁止访问
     */
    PPPayResultCodeForbidden = 1,
    /**
     * 该用户不存在
     */
    PPPayResultCodeUserNotExist = 2,
    /**
     * 必选参数丢失
     */
    PPPayResultCodeParamLost = 3,
    /**
     * PP币余额不足
     */
    PPPayResultCodeNotSufficientFunds = 4,
    /**
     * 该游戏数据不存在
     */
    PPPayResultCodeGameDataNotExist = 5,
    /**
     * 开发者数据不存在
     */
    PPPayResultCodeDeveloperNotExist = 6,
    /**
     * 该区数据不存在
     */
    PPPayResultCodeZoneNotExist = 7,
    /**
     * 系统错误
     */
    PPPayResultCodeSystemError = 8,
    /**
     * 购买失败
     */
    PPPayResultCodeFail = 9,
    /**
     * 与开发商服务器通信失败，如果长时间未收到商品请联系PP客服：电话：020-38276673　 QQ：800055602
     */
    PPPayResultCodeCommunicationFail = 10,
    /**
     * 开发商服务器未成功处理该订单，如果长时间未收到商品请联系PP客服：电话：020-38276673　 QQ：800055602
     */
    PPPayResultCodeUntreatedBillNo = 11,
    
    /**
     * 用户中途取消
     */
    PPPayResultCodeCancel = 12,
    
    /**
     * 非法访问，可能用户已经下线
     */
    PPPayResultCodeUserOffLine = 88,
}PPPayResultCode;

/**
 *  银联支付结果 通知
 */
#define PP_CUPPAY_RESULT_NOTIFICATION  @"PPCUPPayResultNotification"



