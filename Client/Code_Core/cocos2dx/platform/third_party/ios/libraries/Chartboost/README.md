# Chartboost for iOS

*Version 4.5.1*

The Chartboost iOS SDK is the cornerstone of the Chartboost network. It
provides the functionality for showing interstitials, More-Apps pages, and
tracking in-app purchase revenue.


### Usage

Integrating Chartboost takes two easy steps:

 1. Drop the Chartboost folder into your Xcode project.
    
    Ensure you are linking against the following frameworks: `QuartzCore`,
    `SystemConfiguration`, `StoreKit`, `CoreData`, `CoreMedia`, `AVFoundation`, and `CoreGraphics`.  Weak-link
    `AdSupport.framework` by selecting "Optional" next to it in build phases.

 2. Instantiate the Chartboost SDK in your `applicationDidBecomeActive` method, like this:
    
        #import "Chartboost.h"
        
        - (void)applicationDidBecomeActive:(UIApplication *)application        
            
            // initialize the Chartboost library
            [Chartboost startWithAppId:@"YOUR_CHARTBOOST_APP_ID" 
            			  appSignature:@"YOUR_CHARTBOOST_APP_SIGNATURE" 
            			      delegate:self];
              
            // Show an interstitial ad    
            [[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
            
        }


### Dive deeper

For more common use cases, visit our [online documentation](https://help.chartboost.com/documentation/ios).

Check out our header file `Chartboost.h` for the full API
specification.

If you encounter any issues, do not hesitate to contact our happy support team
at [support@chartboost.com](mailto:support@chartboost.com).
