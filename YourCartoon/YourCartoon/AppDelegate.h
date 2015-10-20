//
//  AppDelegate.h
//  YourCartoon
//
//  Created by Binh Le on 10/16/15.
//  Copyright © 2015 Binh Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class ConfigurationObj;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) ConfigurationObj *configuration;
@property (strong, nonatomic) NSMutableArray *youtubePlaylists;
@property (strong, nonatomic) NSMutableArray *youtubeVideos;

@end

