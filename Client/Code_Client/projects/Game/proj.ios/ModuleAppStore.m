#import "ModuleAppStore.h"
#import <CFNetwork/CFNetwork.h>
#import <QuartzCore/QuartzCore.h>
#import "DataStorage.h"
#import "GateKeeper.h"
#import "apiforlua.h"
#define FUNCTION_IOS_VERSION_BEGIN(ver)  \
NSString *curVersion = [[UIDevice currentDevice] systemVersion]; \
if ([curVersion compare:@#ver] == NSOrderedDescending || [curVersion compare:@#ver] == NSOrderedSame) {

#define FUNCTION_IOS_VERSION_ELSE }else{

#define FUNCTION_IOS_VERSION_END }


#define IAP_PAYMENT_REQUEST 5
#define IAP_PAYMENT_FINISH 6


//-----------------------------------充值等待用--------------------------------------------//
@interface IWaitControllerLeYou : UIViewController

- (void)show;
- (void)close;
@end
@interface IWaitControllerLeYou () {
    UIWindow *uiWindow;
    UIWindow *otherWindow;
}
@property (nonatomic, retain) UIWindow *uiWindow;
@property (nonatomic, retain) UIWindow *otherWindow;
@end
//-----------------------------------充值等待用--------------------------------------------//
@implementation IWaitControllerLeYou
@synthesize uiWindow;
@synthesize otherWindow;


static IWaitControllerLeYou *waitInstance = nil;

+ (IWaitControllerLeYou*)shared
{
    if(waitInstance == nil){
        waitInstance = [[IWaitControllerLeYou alloc] init];
    }
    return waitInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        
        int width = screenFrame.size.width;
        int height = screenFrame.size.height;
        int x = screenFrame.origin.x;
        int y = screenFrame.origin.y;
        
        if (height > width)
        {
            width = screenFrame.size.height;
            height = screenFrame.size.width;
        }
        NSInteger winWidth = 200;
        NSInteger winHeight = 100;
        
//        x += width / 2;
//        y += height / 2;
        
//        x = (width - winWidth)/2;
//        y = (height - winHeight)/2 -70;
        CGPoint anchor =  CGPointMake(x+90, y+10);
        CGRect frame = CGRectMake(anchor.x, anchor.y, 32, 32);
        UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [progressInd startAnimating];
        
        frame = CGRectMake(anchor.x-180, anchor.y+50, 400, 30);
        UILabel *waitingLable = [[UILabel alloc] initWithFrame:frame];
        
        UIView *theView = [[UIView alloc] initWithFrame:CGRectMake((width - winWidth)/2, (height - winHeight)/2, winWidth, winHeight)];
        theView.backgroundColor = [UIColor blackColor];
        theView.alpha = 0.7;
        
        theView.layer.masksToBounds = YES;
        theView.layer.cornerRadius = 6.0;
        theView.layer.borderWidth = 1.0;
        theView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        [theView addSubview:progressInd];
        [theView addSubview:waitingLable];
        
        progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        waitingLable.text = @"Connecting...";
        waitingLable.textColor = [UIColor whiteColor];
        waitingLable.font = [UIFont systemFontOfSize:20];;
        waitingLable.backgroundColor = [UIColor clearColor];
        waitingLable.textAlignment = NSTextAlignmentCenter;
        
        self.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:theView];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        uiWindow = [[UIWindow alloc] initWithFrame:screenFrame];
        [uiWindow addSubview:self.view];
        FUNCTION_IOS_VERSION_BEGIN(6.0)
        uiWindow.rootViewController = self;
        FUNCTION_IOS_VERSION_ELSE
        [uiWindow addSubview:self.view];
        FUNCTION_IOS_VERSION_END
        [uiWindow setBackgroundColor:[UIColor clearColor]];
        
        otherWindow = [[UIApplication sharedApplication] keyWindow];;
        //[otherWindow retain];
    }
    return self;
}

- (void)show
{
    //otherWindow = [[UIApplication sharedApplication] keyWindow];
    otherWindow.hidden = NO;
    [uiWindow makeKeyAndVisible];
}
- (void)close
{
    otherWindow.hidden = YES;
    [otherWindow makeKeyAndVisible];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
@end

//---------------------------------------------------------------------------------------------//

@interface ModuleAppStore() {
    NSString *loginCallback;
    NSString *switchAccountCallback;
    NSString *nickname;    
}

@property (nonatomic, retain) IWaitControllerLeYou *waitView;

@end


@implementation ModuleAppStore
@synthesize uin;
@synthesize serverId;
@synthesize orderId;
@synthesize receipt;
@synthesize isSandBox;
@synthesize transactionTypeId;
@synthesize finishRetryTimes;
@synthesize updateShopDataTimer;
@synthesize checkNetTimer;
@synthesize currentPaymentDataKey;
@synthesize checkPaymentFinishTimer;
@synthesize selectItemsCount;
@synthesize rechargeProductionIdSet;

static ModuleAppStore *sInstance = nil;

+ (ModuleAppStore*)shared
{
    if(sInstance == nil){
        sInstance = [[ModuleAppStore alloc] init];
    }
    return sInstance;
}

- (id)init
{
    if (self = [super init])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [self beginPaymentFinishTimer];
        selectItemsCount = 0;
    }
    return self;
}

- (BOOL)iapCanMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

-(void)doPayment:(NSString*)paramUin
                :(NSString*)paramServerId
                :(NSString*)paramTransactionTypeId{
    @try {
        self.uin = paramUin;
        self.serverId = paramServerId;
        self.transactionTypeId = paramTransactionTypeId;
        
        if(self.uin.length ==0 || self.serverId.length== 0 || self.transactionTypeId.length== 0 ){
            return ;
        }
        
        NSMutableDictionary* orderInfo = [DataStorage getFirstFinishPaymentOrders];
        if (orderInfo != nil) {
            [self postPaymentFinish:[orderInfo objectForKey:@"orderId"]];
            [[IWaitControllerLeYou shared] show];
        }else if(self.iapCanMakePayments){
            [self postPaymentRequest];
            [[IWaitControllerLeYou shared] show];
        }
    }
    @catch(NSException* exception){
        
    }
}

-(void)postPaymentRequest{
    self.gameProgress = IAP_PAYMENT_REQUEST;
    NSData* sendData= [self getPaymentRequestjsonData];
    if(sendData != nil){
        NSURL *serverurl = [NSURL URLWithString:@GK_PAYMENT_REQUEST];
        [self httpPostMessage:sendData URL:serverurl];
        NSLog(@"发送订单申请－成功！");
    }else{
        [self showBuyErrorWin];
        NSLog(@"发送订单申请－失败！");
    }
}

- (NSData*)getPaymentRequestjsonData{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if(self.uin.length ==0 || self.serverId.length== 0 || self.transactionTypeId.length== 0 ){
        return nil;
    }
    [dictionary setValue:self.uin forKey:@"uin"];
    [dictionary setValue:self.serverId forKey:@"serverId"];
    [dictionary setValue:self.transactionTypeId forKey:@"transactionType"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    [dictionary release];
    return jsonData;
}

-(void)paymentOrdersRequestResponse:(NSData*)data{
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.orderId = [jsonObject objectForKey:@"orderId"];
    self.transactionTypeId = [jsonObject objectForKey:@"transactionType"];
    if ([orderId length] ==0 || [transactionTypeId length]== 0) {
        [self showBuyErrorWin];
        return;
    }
    [self iapBuyProduct:self.transactionTypeId];
    [DataStorage savePaymentOrdersInfo:uin ServerID:serverId OrderID:orderId];
    NSLog(@"订单申请成功！");
}

- (BOOL)iapBuyProduct:(NSString*)productID
{
    NSSet * set = [NSSet setWithArray : @[productID]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    return true;
}

//+void getShopPriceInfo(const char* items){
//    NSString* nsstrItem = [NSString stringWithCString:items encoding:[NSString defaultCStringEncoding]];
//    NSArray* array = [nsstrItem componentsSeparatedByString:@":"];
//    [[ModuleAppStore shared] getShopPriceInfo:array];
//}

-(void)getRechargeProductionIdInfo:(NSString*)itemlist{
    @try {
        if ([itemlist length] > 0) {
            //10300:300;
            NSMutableArray* itemArray = [[NSMutableArray alloc] init];
            rechargeProductionIdSet = [[NSMutableDictionary alloc] init];
            NSArray* productionList = [itemlist componentsSeparatedByString:@";"];
            for(NSString *productionStr in productionList) {
                NSArray* production = [productionStr componentsSeparatedByString:@":"];
                if ([production count] >1) {
                    NSString* configId = [production objectAtIndex:0];
                    NSString* appProductionId = [production objectAtIndex:1];
                    if ([appProductionId length] >0 && [configId length] >0 ) {
                        [rechargeProductionIdSet setObject:configId forKey:appProductionId];
                        [itemArray addObject:appProductionId];
                    }
                }
            }
            if ([itemArray count] >0) {
                [self getShopPriceInfo:itemArray];
            }
        }

    }
    @catch (NSException *exception) {
            }
    @finally {
        
    }
}

-(void)getShopPriceInfo:(NSArray*)items{
    if (items == nil) {
        return;
    }
    selectItemsCount = [items count];
    NSSet * set = [NSSet setWithArray : items];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
/**
 查询产品信息
 */
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    @try{
        NSArray *myProduct = response.products;
        if (myProduct.count <= 0) {
            NSLog(@"无法获取产品信息，购买失败。");
            [self showBuyErrorWin];
            return;
        }
        
        if (selectItemsCount == [myProduct count]) {
            if (rechargeProductionIdSet == nil) {
                return ;
            }
            NSNumberFormatter *numberFormatter;
            NSString *formattedString;
            SKProduct* pro;
            NSMutableDictionary* shopPriceArr = [[NSMutableDictionary alloc] initWithCapacity:0];
            NSString* productID = @"";
            for (NSInteger index = 0; index < selectItemsCount; index++) {
                pro =response.products[index];
                numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [numberFormatter setLocale:pro.priceLocale];
                formattedString = [numberFormatter stringFromNumber:pro.price];
                productID = pro.productIdentifier;
                productID = [rechargeProductionIdSet objectForKey:productID];
                
                
                [shopPriceArr setValue:formattedString forKey:productID];
            }
            [DataStorage wirteShopPriceInfo:shopPriceArr];
            [shopPriceArr release];
            return;
        }
        SKProduct* pro =response.products[0];
        NSLog(@"%@", pro.localizedDescription);
        NSLog(@"%@",pro.localizedTitle  );
        NSLog(@"%@",pro.price);
        NSLog(@"%@",pro.priceLocale);
        NSLog(@"%@",pro.productIdentifier);
        
        //    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        //    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        //    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        //    [numberFormatter setLocale:pro.priceLocale];
        //    NSString *formattedString = [numberFormatter stringFromNumber:pro.price];
        //
        //
        //    // 这里获得的就是 “货币符号＋金额”
        //    const char *priceS = [formattedString cStringUsingEncoding:NSUTF8StringEncoding];
        
        SKPayment * payment = [SKPayment paymentWithProduct : myProduct[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    }
    @catch(NSException* exception){
        
    }
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction
{
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSString * tReceipt = [ModuleAppStore base64forData:[transaction transactionReceipt]];
    currentPaymentDataKey = [DataStorage addFinishPaymentOrders:uin ServerID:serverId OrderID:orderId Receipt:tReceipt];
	if ([productIdentifier length] > 0 && [currentPaymentDataKey length]>0) {
		// 向自己的服务器验证购买凭证
        finishRetryTimes = 0;
        [self postPaymentFinish:currentPaymentDataKey];
	}
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self clearOrdersInfo];
    [DataStorage clearPaymentOrdersInfo];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(BOOL)postPaymentFinish:(NSString*)pOrderId{
    if (pOrderId == nil) {
        return false;
    }
    self.gameProgress = IAP_PAYMENT_FINISH;
    NSData* sendData= [self getPaymentFinishJsonData:pOrderId];
    if(sendData != nil){
        NSURL *serverurl = [NSURL URLWithString:@GK_PAYMENT_FINISH];
        [self httpPostMessage:sendData URL:serverurl];
        NSLog(@"发送完成订单请求－成功！");
        return true;
    }
    [self showBuyErrorWin];
    [self beginPaymentFinishTimer];
    NSLog(@"发送完成订单请求－失败！");
    return false;
}

- (NSData*)getPaymentFinishJsonData:(NSString*)pOrderId{
    if (pOrderId == nil || [pOrderId length] ==0) {
        return nil;
    }
    NSMutableDictionary *payOrderInfoDic = [DataStorage getFinishPaymentOrders:pOrderId];
    isSandBox = @"0";
    [payOrderInfoDic setValue:isSandBox forKey:@"isSandBox"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payOrderInfoDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
        return nil;
    }
    return jsonData;
}

-(void)paymentOrdersFinishResponse:(NSData*)data{
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSString* state = [jsonObject objectForKey:@"state"];
    NSString* torderId = [jsonObject objectForKey:@"orderId"];
    NSInteger stResult = [state intValue];
    
    if(stResult > 0 && stResult < 59 && finishRetryTimes < 3){
        finishRetryTimes++;
        [self postPaymentFinish:currentPaymentDataKey];
        //重试
        return ;
    }
    if ([torderId isEqualToString:currentPaymentDataKey]) {
        currentPaymentDataKey = @"";
        [[IWaitControllerLeYou shared] close];
        OnPayResult();
    }else{
        [self beginUpdateShopTimer];
    }

    [DataStorage removeFinishPaymentOrders:torderId];
    finishRetryTimes = 0;
    self.gameProgress  = 0;
    NSLog(@"交易完成！");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    @try{
        for (SKPaymentTransaction *transaction in transactions)
        {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchasing:
                    // Item is still in the process of being purchased
                    break;
                case SKPaymentTransactionStatePurchased:
                    [self completeTransaction:transaction];
                    break;
                case SKPaymentTransactionStateFailed:
                    [self failedTransaction:transaction];
                    break;
                case SKPaymentTransactionStateRestored:
                    [self restoreTransaction:transaction];
                    break;
            }
        }
    }
    @catch(NSException* exception){
        
    }
}
- (void)failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled) {
		NSLog(@"购买失败:%@",transaction.error);
        [self showBuyErrorWin];
	}
	else {
		NSLog(@"用户取消交易");
	}
    [self endCheckTimer];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [DataStorage clearPaymentOrdersInfo];
    [self clearOrdersInfo];
    [[IWaitControllerLeYou shared] close];
    [self beginPaymentFinishTimer];
}

-(void)httpPostMessage:(NSData*)data URL:(NSURL*)serverurl{
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:serverurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:45];
    
    [request setURL:serverurl];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    
    NSMutableData *postBody = [NSMutableData dataWithData:data];
    //post
    [request setHTTPBody:postBody];
    
    //第三步，连接服务器
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [self beginCheckTimer];
}

-(void)beginCheckTimer{
    [self endCheckTimer];
    checkNetTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
}

-(void)endCheckTimer{
    if(checkNetTimer != nil){
        [checkNetTimer invalidate];
        checkNetTimer = nil;
    }
}
-(void)scrollTimer{
    [self endCheckTimer];
    [self showReconnectWin];
}

-(void)beginUpdateShopTimer{
    [self endUpdateShopTimer];
    updateShopDataTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(UpdateShopTimer) userInfo:nil repeats:NO];
}

-(void)endUpdateShopTimer{
    if(updateShopDataTimer != nil){
        [updateShopDataTimer invalidate];
        updateShopDataTimer = nil;
    }
}
-(void)UpdateShopTimer{
    [self endUpdateShopTimer];
    [[IWaitControllerLeYou shared] close];
    OnPayResult();
}

-(void)beginPaymentFinishTimer{
    [self endCheckTimer];
    checkPaymentFinishTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(paymentFinishhandler) userInfo:nil repeats:YES];
    [self paymentFinishhandler];
}

-(void)endPaymentFinishTimer{
    if(checkPaymentFinishTimer != nil){
        [checkPaymentFinishTimer invalidate];
        checkPaymentFinishTimer = nil;
    }
}

-(void)paymentFinishhandler{
    @try{
        NSMutableDictionary* orderInfo = [DataStorage getFirstFinishPaymentOrders];
        if (orderInfo != nil) {
            [self postPaymentFinish:[orderInfo objectForKey:@"orderId"]];
        }else{
            [self endPaymentFinishTimer];
        }
    }
    @catch(NSException* exception){
        
    }
    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSInteger code =[res statusCode];
        if ( code < 200 || code >= 300) {
            NSLog(@"error");
            //出错了
            [self endCheckTimer];
            [self showReconnectWin];
        }
    }
    self.receiveData = [[NSMutableData alloc]init];
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
    
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try{
        [self endCheckTimer];
        switch (self.gameProgress) {
            case IAP_PAYMENT_REQUEST:
                [self paymentOrdersRequestResponse:self.receiveData];
                break;
            case IAP_PAYMENT_FINISH:
                [self paymentOrdersFinishResponse:self.receiveData];
                break;
            default:
                break;
        }
        
        [self.receiveData release];
    }
    @catch(NSException* exception){
        
    }

}

-(void) showReconnectWin{
    UIAlertView *alertView ;
    switch (self.gameProgress) {
        case IAP_PAYMENT_FINISH:
            alertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect with the server. Check your internet connection and try again." delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
            break;
        default:
            alertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect with the server. Check your internet connection and try again." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Try again", nil];
            break;
    }

    [alertView show];
    [alertView release];
}

-(void) showBuyErrorWin{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Cannot connect to iTunes Store" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 || self.gameProgress == IAP_PAYMENT_FINISH){
        [self reConnection];
    }else{
        [[IWaitControllerLeYou shared] close];
        [self endCheckTimer];
        [self beginPaymentFinishTimer];
    }
}

-(void)reConnection{
    [self beginPaymentFinishTimer];
    switch (self.gameProgress) {
        case IAP_PAYMENT_REQUEST:
            [self postPaymentRequest];
            break;
        case IAP_PAYMENT_FINISH:
            [self postPaymentFinish:currentPaymentDataKey];
            break;
        default:
            break;
    }
}

//-(void)chcekPlayerPaymentOrdersInfo{
//    //检查是否有未完成的订单
//    [self postPaymentFinish];
//}

-(void)clearOrdersInfo{
    uin = @"";
    serverId =@"";
    orderId=@"";
    receipt=nil;
    isSandBox=@"";
}

- (void)checkOrderInfo{
    if ([uin length] ==0 ||[serverId length] ==0||[orderId length] ==0) {
        NSMutableDictionary* orderObject = [DataStorage getPaymentOrdersInfo];
        if (orderObject != nil) {
            uin = [orderObject objectForKey:@"uin"];
            serverId = [orderObject objectForKey:@"serverId"];
            orderId= [orderObject objectForKey:@"orderId"];
        }
    }
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end

//    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
//    if (transactions.count > 0) {
//        //检测是否有未完成的交易
//        SKPaymentTransaction* transaction = [transactions firstObject];
//        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
//            [self completeTransaction:transaction];
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//            return;
//        }
//    }
