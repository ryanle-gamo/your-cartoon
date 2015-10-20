//
//  AP_SDK.h
//  AP_SDK
//
//  Created by Swapna Chavan on 19/11/14.
//  Copyright (c) 2014 Airpush. All rights reserved.
//


@interface AP_SDK : NSObject

// setUp SDK with proper App Portal Identifier. Portal Identifier is generated from manage.airpush.com. Read SDK documents for more details on how to get this.

// You should call this function only once when your application launch.

+(void) setupForAppPortalIdentifier:(NSString *) apPortalIdentifier;

//@optional: It is a optional function
// Implement ads loading call back status

+(void) setCallBackDelegate:(id) inCallbackDelegate;

// Call showAdWithViewController to display ads in a ViewController.

// You should call this function on all pages/screens/ViewControllers where you have to display Ads.

+(void) showAdWithViewController:(UIViewController *)adPresenter withPlacementId:(int)placementid isTestMode:(BOOL) testMode;

// Call showMediationAdWithSize method if you are using airpush SDK with Mediation.

+(void) showMopubAdWithSize:(CGSize)inAdSize andMopubDelegate:(id)inMopubDelegate isTestMode:(BOOL) testMode;


+(void) showMobfoxAdWithSize:(CGSize)inAdSize andMobfoxDelegate:(id)inMobfoxDelegate isTestMode:(BOOL) testMode;

// Call stopLoading to stop Ads rendering.

+(void) stopLoadingAd;


@end
