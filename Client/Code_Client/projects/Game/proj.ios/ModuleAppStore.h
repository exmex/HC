#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

//In app purchase
@interface ModuleAppStore : NSObject<
SKProductsRequestDelegate,
SKRequestDelegate,
SKPaymentTransactionObserver>{
    NSURLConnection *connection;
}

+ (ModuleAppStore*)shared;
//- (BOOL)iapCanMakePayments;
//- (BOOL)iapBuyProduct:(NSString*)productID;
////-(void)chcekPlayerPaymentOrdersInfo;
-(void)doPayment:(NSString*)paramUin
                :(NSString*)paramServerId
                :(NSString*)paramTransactionTypeId;
-(void)getShopPriceInfo:(NSArray*)items;

-(void)getRechargeProductionIdInfo:(NSString*)itemlist;

@property (nonatomic) NSInteger *paymentProgress;

@property (nonatomic, retain) NSString *uin;
//服务器id
@property (nonatomic, retain) NSString *serverId;
//订单id
@property (nonatomic, retain) NSString *orderId;
//苹果商店验证串号
@property (nonatomic, retain) NSData *receipt;
//是否沙箱测试
@property (nonatomic, retain) NSString *isSandBox;
//商品id
@property (nonatomic, retain) NSString *currentPaymentDataKey;

@property (nonatomic, retain) NSString *transactionTypeId;

@property (retain,readwrite) NSMutableData* receiveData;

@property (nonatomic) NSInteger finishRetryTimes;

@property (nonatomic, strong) NSTimer *checkNetTimer;
@property (nonatomic, strong) NSTimer *updateShopDataTimer;

@property (nonatomic, strong) NSTimer *checkPaymentFinishTimer;

@property (nonatomic) NSInteger selectItemsCount;

@property (nonatomic, retain) NSMutableDictionary *rechargeProductionIdSet;

@property NSInteger gameProgress;
@end