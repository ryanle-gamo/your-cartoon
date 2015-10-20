//
//  DetailViewController.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/6/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StartApp/StartApp.h>

@class VideoObject;
@class PLObject;
@interface DetailViewController : UIViewController <GADInterstitialDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        selectedIndex:(NSInteger)selectedIndex
             playlist:(PLObject *)playlist;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        selectedVideo:(VideoObject *)video;

@end
