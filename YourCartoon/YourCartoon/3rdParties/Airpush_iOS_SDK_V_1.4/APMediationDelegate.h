//
//  APMediationDelegate.h
//  AP_SDK
//
//  Created by Tapasya Tandon on 31/01/15.
//  Copyright (c) 2015 Airpush. All rights reserved.
//

@protocol APMediationDelegate <NSObject>

- (void)onMediationAdLoaded:(UIView *) adView;
- (void)onMediationAdFailedWithError:(NSString *)error;
- (void)OnMediationAdClickActionStarted;
- (void)OnMediationAdClickActionCompleted;
- (void)OnMediationAdEnteredBackground;
- (void)onMediationAdClosed;
- (void)disableAutoAdRefresh;
- (void)enableAutoAdRefresh;

@end

