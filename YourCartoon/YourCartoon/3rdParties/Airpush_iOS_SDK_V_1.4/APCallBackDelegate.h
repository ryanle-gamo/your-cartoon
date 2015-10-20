//
//  APCallBackDelegate.h
//  AP_SDK
//
//  Created by Arun Dhwaj on 28/01/15.
//  Copyright (c) 2015 Airpush. All rights reserved.
//

#ifndef AP_SDK_APCallBackDelegate_h
#define AP_SDK_APCallBackDelegate_h
#endif

@protocol  APCallBackDelegate <NSObject>

-(void) onAdLoading;
-(void) onAdLoaded;

-(void) onAdClick;
-(void) onClose;

-(void) noAdAvailable;

-(void) onAdError:(NSString*) message;
-(void) onSDKIntegrationError:(NSString*) message;

@end


