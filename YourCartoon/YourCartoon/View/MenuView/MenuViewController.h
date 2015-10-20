//
//  MenuViewController.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/9/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLObject;
@protocol MenuViewDelegate <NSObject>
- (void)touchMenu:(PLObject *)playlist;
- (void)touchCancel;
@end

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray *)array;
@property (nonatomic, weak) id<MenuViewDelegate> menuDelegate;
@end
