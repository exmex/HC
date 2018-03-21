//
//  InAppPurchaseManager.m
//  com4lovesSDK
//
//  Created by fish on 13-8-22.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "SDKUtility.h"
#import "com4lovesSDK.h"

//#define kInAppPurchaseProUpgradeProductId @"100zuanshi"

@interface InAppPurchaseManager()
{
    SKProduct * proUpgradeProduct;
    SKProductsRequest* productsRequest;
    NSString* lastBroughtPruductID;
    NSData* lastBroughtReceipt;
    
}
@end

@implementation InAppPurchaseManager

+ (InAppPurchaseManager *)sharedInstance
{
    static InAppPurchaseManager *_instance = nil;
    if (_instance == nil) {
        _instance = [[InAppPurchaseManager alloc] init];
    }
    return _instance;
    
}
- (void)requestProduct : (NSString*) productID
{
    NSSet *productIdentifiers = [NSSet setWithObject:productID ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    proUpgradeProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
    if (proUpgradeProduct)
    {
        YALog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        YALog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        YALog(@"Product price: %@" , proUpgradeProduct.price);
        YALog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        YALog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    //[self requestProUpgradeProductData];

}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProduct: (NSString*) productID
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
    lastBroughtPruductID = productID;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (NSData*) getRecept
{
    return lastBroughtReceipt;
}
#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:lastBroughtPruductID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:lastBroughtPruductID])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        lastBroughtReceipt = [transaction transactionReceipt];//[[NSString alloc] initWithData: encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
        
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                       message:[com4lovesSDK getLang:@"buy_faild"]
                                                      delegate:nil
                                             cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];

}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                [[SDKUtility sharedInstance] setWaiting:NO];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                [[SDKUtility sharedInstance] setWaiting:NO];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                [[SDKUtility sharedInstance] setWaiting:NO];
                break;
            case SKPaymentTransactionStatePurchasing:
                [[SDKUtility sharedInstance] setWaiting:YES];
            default:
                break;
        }
    }
}


@end
