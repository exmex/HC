#include "FacebookController.h"

#include <Social/Social.h>
#include <Social/SLComposeViewController.h>
#include "JSON.h"
#import "apiforlua.h"


static const NSString *kuFBAppID = @"423346011140901";

NSString *FacebookController::ms_nsstrFirstName = NULL;

NSString *FacebookController::ms_uPlayerFBID = NULL;

bool FacebookController::ms_bIsLoggedIn = false;

FBFrictionlessRecipientCache *FacebookController::ms_friendCache = NULL;

void FacebookController::CreateNewSession() {
    //[FBSession setDefaultAppID: @"423346011140901"];
    FBSession * session = [[FBSession alloc] init];
    [FBSession setActiveSession: session];
}

bool FacebookController::IsLoggedIn() {
    return ms_bIsLoggedIn;
}

void FacebookController::SetLoggedIn(bool bLoggedIn) {
    ms_bIsLoggedIn = bLoggedIn;
}

void FacebookController::OpenSession(void (*callback)(bool)) {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"public_profile", @"user_friends", nil];

    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions: permissions allowLoginUI: false completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {

        // Did something go wrong during login? I.e. did the user cancel?

        if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateClosed || status == FBSessionStateCreatedOpening) {
            ms_bIsLoggedIn = false;
            callback(false);
        }
        else {
            ms_bIsLoggedIn = true;
            callback(true);
        }
    }];
}

void FacebookController::Login(void (*callback)(bool)) {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
    @
    "email", @
    "public_profile", @
    "user_friends",
            nil];

    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession
    openActiveSessionWithReadPermissions:
    permissions
    allowLoginUI:
    true
    completionHandler:
    ^(FBSession *session, FBSessionState status, NSError *error) {

        // Did something go wrong during login? I.e. did the user cancel?

        if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateClosed || status == FBSessionStateCreatedOpening) {

            // If so, just send them round the loop again
            [[FBSession
            activeSession] closeAndClearTokenInformation];
            [FBSession
            setActiveSession:
            nil];
            CreateNewSession();
            ms_bIsLoggedIn = false;
            callback(false);
        }
        else {
            ms_bIsLoggedIn = true;
            callback(true);
        }
    }];
}

void FacebookController::Logout(void (*callback)(bool)) {
    // Log out of Facebook and reset our session
    [[FBSession
    activeSession] closeAndClearTokenInformation];
    [FBSession
    setActiveSession:
    nil];
    ms_bIsLoggedIn = false;
    callback(true);
}

void FacebookController::CheckForPermission(NSString *permission, void (*callback)(bool)) {
    FBRequest * req = [[FBRequest
    alloc] initWithSession:[FBSession
    activeSession] graphPath:
    @
    "/me/permissions"];

    [req
    startWithCompletionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {
        if (result && !error) {

            NSArray *fetchedPermissionData = [[NSArray alloc] initWithArray:[result
            objectForKey:
            @
            "data"]];

            bool bFound = false;

            for (NSDictionary *currper in fetchedPermissionData) {
                if ( [[currper
                valueForKey:
                @
                "permission"] caseInsensitiveCompare:
                permission] == NSOrderedSame ) {
                    if ([[currper
                    valueForKey:
                    @
                    "status"] caseInsensitiveCompare:
                    @
                    "granted"] == NSOrderedSame) {
                        bFound = true;
                        break;
                    }
                }
            }

            callback(bFound);
        }
        else {
            NSLog(@
            "Something went wrong...");
        }
    }];
}


void FacebookController::FetchUserDetails(void (*callback)(bool)) {
    // Start the facebook request
    [[FBRequest
    requestForMe]
    startWithCompletionHandler:
    ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error) {
        // Did everything come back okay with no errors?
        if (!error && result) {
            // If so we can extract out the player's Facebook ID and first name
            ms_nsstrFirstName = [[NSString alloc] initWithString:
            result.first_name];
            //ms_uPlayerFBID =  [result.id
            //longLongValue];
            ms_uPlayerFBID = [[NSString alloc] initWithString:
                          result.id];

            callback(true);
        }
        else {
            callback(false);
        }
    }];
}

void FacebookController::FetchFriendDetails(void (*callback)(NSArray *)) {
    [FBRequestConnection
    startForMyFriendsWithCompletionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {

        if (!error && result) {
            NSArray *fetchedFriendData = [[NSArray alloc] initWithArray:[result
            objectForKey:
            @
            "data"]];
            callback(fetchedFriendData);
        }
        else {
            callback(nil);
        }

    }];
}


void FacebookController::FetchInvitableFriendDetails(void (*callback)(NSArray *)) {
    FBRequest * req = [[FBRequest
    alloc] initWithSession:[FBSession
    activeSession] graphPath:
    @
    "me/invitable_friends"];

    [req
    startWithCompletionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error && result) {
            NSArray *fetchedFriendData = [[NSArray alloc] initWithArray:[result
            objectForKey:
            @
            "data"]];
            callback(fetchedFriendData);
        }
        else {
            callback(nil);
        }

    }];
}


void FacebookController::ProcessIncomingURL(NSURL *targetURL, void (*callback)(NSString *, NSString *)) {
    // Process the incoming url and see if it's of value...

    NSRange range = [targetURL.query
    rangeOfString:
    @
    "notif"
    options:
    NSCaseInsensitiveSearch];

    // If the url's query contains 'notif', we know it's coming from a notification - let's process it
    if (targetURL.query && range.location != NSNotFound) {
        // Yes the incoming URL was a notification
        ProcessIncomingRequest(targetURL, callback);
    }

    range = [targetURL.path
    rangeOfString:
    @
    "challenge_brag"
    options:
    NSCaseInsensitiveSearch];

    // If the url's path contains 'challenge_brag', we know it comes from a feed post
    if (targetURL.path && range.location != NSNotFound) {
        // Yes the incoming URL was a notification
        ProcessIncomingFeed(targetURL, callback);
    }
}

void FacebookController::ProcessIncomingRequest(NSURL *targetURL, void (*callback)(NSString *, NSString *)) {
    // Extract the notification id
    NSArray *pairs = [targetURL.query
    componentsSeparatedByString:
    @
    "&"];
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair
        componentsSeparatedByString:
        @
        "="];
        NSString *val = [[kv
        objectAtIndex:
        1]
        stringByReplacingPercentEscapesUsingEncoding:
        NSUTF8StringEncoding];

        [queryParams
        setObject:
        val
        forKey:[kv
        objectAtIndex:
        0]];

    }

    NSString *requestIDsString = [queryParams
    objectForKey:
    @
    "request_ids"];
    NSArray *requestIDs = [requestIDsString
    componentsSeparatedByString:
    @
    ","];

    FBRequest * req = [[FBRequest
    alloc] initWithSession:[FBSession
    activeSession] graphPath:[requestIDs
    objectAtIndex:
    0]];

    [req
    startWithCompletionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {

            if ([result
            objectForKey:
            @
            "from"])
            {
                NSString *from = [[result
                objectForKey:
                @
                "from"] objectForKey:
                @
                "name"];
                NSString *id = [[result
                objectForKey:
                @
                "from"] objectForKey:
                @
                "id"];

                callback(from, id);
            }

        }

    }];
}

void FacebookController::ProcessIncomingFeed(NSURL *targetURL, void (*callback)(NSString *, NSString *)) {
    // Here we process an incoming link that has launched the app via a feed post

    // Here is extract out the FBID component at the end of the brag, so 'challenge_brag_123456' becomes just 123456
    NSString *val = [[targetURL.path
    componentsSeparatedByString:
    @
    "challenge_brag_"] lastObject];

    FBRequest * req = [[FBRequest
    alloc] initWithSession:[FBSession
    activeSession] graphPath:
    val];

    // With the FBID extracted, we have enough information to go ahead and request the user's profile picture
    // But we also need their name, so here we make a request to http://graph.facebook.com/USER_ID to get their basic information
    [req
    startWithCompletionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // If the result came back okay with no errors...
        if (result && !error) {
            NSString *from = [result
            objectForKey:
            @
            "first_name"];

            callback(from, val);
        }
    }];
}

void FacebookController::SendInvite(NSArray *friendIDs) {
    // 1. No additional parameters provided - enables generic Multi-friend selector

    NSMutableDictionary *params;

    if (friendIDs) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [friendIDs
        componentsJoinedByString:
        @
        ","], @
        "to", nil];
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        nil];
    }


    if (ms_friendCache == NULL) {
        ms_friendCache = [[FBFrictionlessRecipientCache
        alloc] init];
    }

    [ms_friendCache
    prefetchAndCacheForSession:
    nil];


    [FBWebDialogs
    presentRequestsDialogModallyWithSession:
    nil
    message:[NSString stringWithFormat:
    @
    "Come join me in the friend smash times!"]
    title:
    @
    "Smashing Invite!"
    parameters:
    params
    handler:
    ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@
            "Error sending request.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@
                "User canceled request.");
            } else {
                NSLog(@
                "Request Sent.");
            }
        }
    }
    friendCache:
    ms_friendCache];

}


void FacebookController::SendRequest(NSArray *friendIDs, const int nScore) {
    // Normally this won't be hardcoded but will be context specific, i.e. players you are in a match with, or players who recently played the game etc
    NSArray *suggestedFriends = [[NSArray alloc] initWithObjects:
    @
    "223400030", @
    "286400088", @
    "767670639", @
    "516910788",
            nil];

    SBJsonWriter * jsonWriter = [SBJsonWriter
    new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:
    @
    "%d", nScore], @
    "challenge_score", nil];
    NSString *challengeStr = [jsonWriter
    stringWithObject:
    challenge];


    // Create a dictionary of key/value pairs which are the parameters of the dialog

    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary *params =   [NSMutableDictionary
    dictionaryWithObjectsAndKeys:
    // 2. Optionally provide a 'to' param to direct the request at a specific user
    [friendIDs
    componentsJoinedByString:
    @
    ","], @
    "to", // Ali
            // 3. Suggest friends the user may want to request, could be game context specific?
            //[suggestedFriends componentsJoinedByString:@","], @"suggestions",
            challengeStr, @
    "data",
            nil];


    if (ms_friendCache == NULL) {
        ms_friendCache = [[FBFrictionlessRecipientCache
        alloc] init];
    }

    [ms_friendCache
    prefetchAndCacheForSession:
    nil];

    [FBWebDialogs
    presentRequestsDialogModallyWithSession:
    nil
    message:[NSString stringWithFormat:
    @
    "I just smashed %d friends! Can you beat it?", nScore]
    title:
    @
    "Smashing!"
    parameters:
    params
    handler:
    ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@
            "Error sending request.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@
                "User canceled request.");
            } else {
                NSLog(@
                "Request Sent.");
            }
        }
    }
    friendCache:
    ms_friendCache];
}

void FacebookController::SendFilteredRequest(const int nScore) {
    // Okay, we're going to filter our friends by their device, we're looking for friends with an iPhone or iPad

    // We're going to place these friends into this container
    NSMutableArray * deviceFilteredFriends = [[NSMutableArray
    alloc] init];

    // We request a list of our friends' names and devices
    [[FBRequest
    requestForGraphPath:
    @
    "me/friends?fields=name,devices"]
    startWithCompletionHandler:
    ^(FBRequestConnection *connection,
            NSDictionary *result,
            NSError *error) {
        // If we received a result with no errors...
        if (!error && result) {
            // Get the result
            NSArray *resultData = [result
            objectForKey:
            @
            "data"];

            // Check we have some friends. If the player doesn't have any friends, they probably need to put down the demo app anyway, and go outside...
            if ([resultData
            count] > 0)
            {
                // Loop through the friends returned
                for (NSDictionary *friendObject in resultData)
                {
                    // Check if devices info available
                    if ([friendObject
                    objectForKey:
                    @
                    "devices"])
                    {
                        // Yep, we know what devices this friend has.. let's extract them
                        NSArray *deviceData = [friendObject
                        objectForKey:
                        @
                        "devices"];

                        // Loop through the list of devices this friend has...
                        for (NSDictionary *deviceObject in deviceData)
                        {
                            // Check if there is a device match, in this case we're looking for iOS
                            if ([@
                            "iOS"
                            isEqualToString: [deviceObject
                            objectForKey:
                            @
                            "os"]])
                            {
                                // If there is a match, add it to the list - this friend has an iPhone or iPad. Hurrah!
                                [deviceFilteredFriends
                                addObject: [friendObject
                                objectForKey:
                                @
                                "id"]];
                                break;
                            }
                        }
                    }
                }
            }

            // Now we have a list of friends with an iOS device, we can send requests to them

            // We create our parameter dictionary as we did before
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            nil];

            // We have the same list of suggested friends
            NSArray *suggestedFriends = [[NSArray alloc] initWithObjects:
            @
            "695755709", @
            "685145706", @
            "569496010", @
            "7963306",
                    nil];


            // Of course, not all of our suggested friends will have iPhones or iPads - we need to filter them down
            NSMutableArray * validSuggestedFriends = [[NSMutableArray
            alloc] init];

            // So, we loop through each suggested friend
            for (NSString *suggestedFriend in suggestedFriends)
            {
                // If they are on our device filtered list, we know they have an iOS device
                if ([deviceFilteredFriends
                containsObject:
                suggestedFriend])
                {
                    // So we can call them valid
                    [validSuggestedFriends
                    addObject:
                    suggestedFriend];
                }
            }

            // If at least one of our suggested friends had an iOS device...
            if ([deviceFilteredFriends
            count] > 0)
            {
                // We add them to the suggest friend param of the dialog
                NSString *selectIDsStr = [validSuggestedFriends
                componentsJoinedByString:
                @
                ","];
                [params
                setObject:
                selectIDsStr
                forKey:
                @
                "suggestions"];
            }

            if (ms_friendCache == NULL) {
                ms_friendCache = [[FBFrictionlessRecipientCache
                alloc] init];
            }

            [FBWebDialogs
            presentRequestsDialogModallyWithSession:
            nil
            message:[NSString stringWithFormat:
            @
            "I just smashed %d friends! Can you beat it?", nScore]
            title:
            nil
            parameters:
            params
            handler:
            ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                if (error) {
                    NSLog(@
                    "Error sending request.");
                } else {
                    if (result == FBWebDialogResultDialogNotCompleted) {
                        NSLog(@
                        "User canceled request.");
                    } else {
                        NSLog(@
                        "Request Sent.");
                    }
                }
            }
            friendCache:
            ms_friendCache];

        }
    }];
}

void FacebookController::SendBrag(const int nScore) {
    // This function will invoke the Feed Dialog to post to a user's Timeline and News Feed
    // It will attemnt to use the Facebook Native Share dialog
    // If that's not supported we'll fall back to the web based dialog.
    NSString *linkURL = [NSString stringWithFormat:
    @
    "https://www.friendsmash.com/challenge_brag_%llu", ms_uPlayerFBID];
    NSString *pictureURL = @
    "http://www.friendsmash.com/images/logo_large.jpg";

    // Prepare the native share dialog parameters
    FBShareDialogParams * shareParams = [[FBShareDialogParams
    alloc] init];
    shareParams.link = [NSURL URLWithString:
    linkURL];
    shareParams.name = @
    "Checkout my Friend Smash greatness!";
    shareParams.caption = @
    "Come smash me back!";
    shareParams.picture = [NSURL URLWithString:
    pictureURL];
    shareParams.description =
    [NSString stringWithFormat:
    @
    "I just smashed %d friends! Can you beat my score?", nScore];

    if ([FBDialogs
    canPresentShareDialogWithParams:
    shareParams]){

        [FBDialogs
        presentShareDialogWithParams:
        shareParams
        clientState:
        nil
        handler:
        ^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if (error) {
                NSLog(@
                "Error publishing story.");
            } else if (results[@
            "completionGesture"] && [results[@
            "completionGesture"] isEqualToString:
        @
            "cancel"]) {
            NSLog(@
            "User canceled story publishing.");
        } else {
            NSLog(@
            "Story published.");
        }
        }];

    } else {

        // Prepare the web dialog parameters
        NSDictionary *params = @{
        @
        "name" : shareParams.name,
                @
        "caption" : shareParams.caption,
                @
        "description" : shareParams.description,
                @
        "picture" : pictureURL,
                @
        "link" : linkURL
    };

    // Invoke the dialog
    [FBWebDialogs
    presentFeedDialogModallyWithSession:
    nil
    parameters:
    params
            handler:
    ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            NSLog(@
            "Error publishing story.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@
                "User canceled story publishing.");
            } else {
                NSLog(@
                "Story published.");
            }
        }
    }];
}

}

void FacebookController::SendScore(const int nScore) {

    NSMutableDictionary *params =   [NSMutableDictionary
    dictionaryWithObjectsAndKeys:
    [NSString stringWithFormat:
    @
    "%d", nScore], @
    "score",
            nil];

    NSLog(@
    "Fetching current score");

    // Get the score, and only send the updated score if it's highter
    [FBRequestConnection
    startWithGraphPath:[NSString stringWithFormat:
    @
    "%llu/scores", ms_uPlayerFBID] parameters:
    params
    HTTPMethod:
    @
    "GET"
    completionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {

        if (result && !error) {

            int nCurrentScore = [[[[result
            objectForKey:
            @
            "data"] objectAtIndex:
            0] objectForKey:
            @
            "score"] intValue];

            NSLog(@
            "Current score is %d", nCurrentScore);

            if (nScore > nCurrentScore) {

                NSLog(@
                "Posting new score of %d", nScore);

                [FBRequestConnection
                startWithGraphPath:[NSString stringWithFormat:
                @
                "%llu/scores", ms_uPlayerFBID] parameters:
                params
                HTTPMethod:
                @
                "POST"
                completionHandler:
                ^(FBRequestConnection *connection, id result, NSError *error) {

                    NSLog(@
                    "Score posted");
                }];
            }
            else {
                NSLog(@
                "Existing score is higher - not posting new score");
            }
        }
    }];
}

void FacebookController::SendAchievement(eGameAchievements achievement) {

    NSArray *achievementURLs = [NSArray arrayWithObjects:
    @
    "http://www.friendsmash.com/opengraph/achievement_50.html",
            @
    "http://www.friendsmash.com/opengraph/achievement_100.html",
            @
    "http://www.friendsmash.com/opengraph/achievement_150.html",
            @
    "http://www.friendsmash.com/opengraph/achievement_200.html",
            @
    "http://www.friendsmash.com/opengraph/achievement_x3.html",
            nil];

    NSMutableDictionary *params =   [NSMutableDictionary
    dictionaryWithObjectsAndKeys:
    [NSString stringWithFormat:
    @
    "%@", [achievementURLs
    objectAtIndex:
    achievement]], @
    "achievement",
            nil];

    [FBRequestConnection
    startWithGraphPath:[NSString stringWithFormat:
    @
    "%llu/achievements", ms_uPlayerFBID] parameters:
    params
    HTTPMethod:
    @
    "POST"
    completionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {
    }];
}

void FacebookController::GetScores(void (*callback)(NSArray *)) {
    [FBRequestConnection
    startWithGraphPath:[NSString stringWithFormat:
    @
    "%llu/scores?fields=score,user", kuFBAppID] parameters:
    nil
    HTTPMethod:
    @
    "GET"
    completionHandler:
    ^(FBRequestConnection *connection, id result, NSError *error) {

        if (!error && result) {
            NSArray *fetchedScoreData = [[NSArray alloc] initWithArray:[result
            objectForKey:
            @
            "data"]];
            callback(fetchedScoreData);
        }
        else {
            callback(nil);
        }

    }];
}


void FacebookController::RequestWritePermissions() {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
    @
    "publish_actions", nil];

    [[FBSession
    activeSession] requestNewPublishPermissions:
    permissions
    defaultAudience:
    FBSessionDefaultAudienceFriends
    completionHandler:
    ^(FBSession *session, NSError *error) {
        NSLog(@
        "Reauthorized with publish permissions.");
    }];
}

void FacebookController::ReRequestFriendPermission() {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
    @
    "user_friends", nil];

    [[FBSession
    activeSession] requestNewReadPermissions:
    permissions
    completionHandler:
    ^(FBSession *session, NSError *error) {

        if (!error) {
            NSLog(@
            "Reauthorized with publish permissions.");
        }
        else {
            NSLog(@
            "Sadly not...");
        }

    }];
}

void FacebookController::doLog(bool bLoggedIn) {
    NSLog(@"facebook doLog calback");
    if(bLoggedIn){
        OnFacebookConnectResult(1);
        NSLog(@"facebook doLog :true");
    }else{
        OnFacebookConnectResult(0);
        NSLog(@"facebook doLog :false");
    }
    
}


