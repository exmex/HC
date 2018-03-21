#ifndef HEROCHARGE_FACEBOOKCONTROLLER
#define HEROCHARGE_FACEBOOKCONTROLLER

#import "RootViewController.h"
#import "AppController.h"

#import <Accounts/Accounts.h>

class FacebookController {

public:

    enum eGameAchievements {
        kACHIEVEMENT_SCORE50 = 0,
        kACHIEVEMENT_SCORE100,
        kACHIEVEMENT_SCORE150,
        kACHIEVEMENT_SCORE200,
        kACHIEVEMENT_SCOREx3,
        kACHIEVEMENT_MAX
    };


    FacebookController();

    virtual ~FacebookController();

    static void CreateNewSession();

    static void Login(void (*callback)(bool));

    static void OpenSession(void (*callback)(bool));

    static void Logout(void (*callback)(bool));
    
    static void doLog(bool);

    static void CheckForPermission(NSString *permission, void (*callback)(bool));

    static bool IsLoggedIn();

    // Method for forcing this in the case of a login powered by parse
    static void SetLoggedIn(bool);

    static void FetchUserDetails(void (*callback)(bool));

    static void FetchFriendDetails(void (*callback)(NSArray *));

    static void FetchInvitableFriendDetails(void (*callback)(NSArray *));

    static void ProcessIncomingURL(NSURL *targetURL, void (*callback)(NSString *, NSString *));

    static void ProcessIncomingRequest(NSURL *targetURL, void (*callback)(NSString *, NSString *));

    static void ProcessIncomingFeed(NSURL *targetURL, void (*callback)(NSString *, NSString *));

    static void SendInvite(NSArray *friendIDs);

    static void SendRequest(NSArray *friendIDs, const int nScore);

    static void SendFilteredRequest(const int nScore);

    static void SendBrag(const int nScore);

    static void SendScore(const int nScore);

    static void SendAchievement(eGameAchievements achievement);

    static void GetScores(void (*callback)(NSArray *));

    static void RequestWritePermissions();

    static void ReRequestFriendPermission();

    static NSString *GetUserFirstName() {
        return ms_nsstrFirstName;
    }

    static NSString *GetUserFBID() {
        return ms_uPlayerFBID;
    }


private:

    static NSString *ms_nsstrFirstName;
    static NSString *ms_uPlayerFBID;
    static bool ms_bIsLoggedIn;

    static FBFrictionlessRecipientCache *ms_friendCache;

};


#endif
