//
//  GridViewController.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/6/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StartApp/StartApp.h>
#import "ContentGuideView.h"

@class PLObject;
@interface GridViewController : UIViewController <ContentGuideViewDelegate, ContentGuideViewDataSource, GADInterstitialDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(PLObject *)plObject;
@end
