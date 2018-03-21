//
//  Platform.h
//  hero
//
//  Created by Lyon on 10/6/14.
//
//

#import <Foundation/Foundation.h>


@class AppController;

@interface PlatformSupport : NSObject{
    NSURLConnection *connection;
    AppController* appController;
    NSString* alertWinType;
}


// Game Center 玩家id
@property (retain,readwrite) NSString * currentPlayerID;
@property (retain,readwrite) NSMutableData* receiveData;
@property NSInteger gameProgress;


// isGameCenterAuthenticationComplete is set after authentication, and authenticateWithCompletionHandler's completionHandler block has been run. It is unset when the applicaiton is backgrounded.
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;

-(void)gameCenterLogin;
-(void)postWebLogin;
-(void)postCheckGameCenter;
-(void)postBindGameCenter;
@end
