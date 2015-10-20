//
//  DataManager.m
//  HowToMakeClay
//
//  Created by Binh Le on 7/13/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "DataManager.h"
#import "VideoObject.h"
#import "ConfigurationObj.h"
#import "AppDelegate.h"

#define SPLIT_SIGN @"_YOURCARTOON_"
static DataManager *sharedInstance = nil;
static AppDelegate *appDelegate = nil;
@implementation DataManager

+ (instancetype)getSharedInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[DataManager alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        sharedInstance.imagePath = [paths objectAtIndex:0];
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    });
    return sharedInstance;
}

- (NSString *)makeStringFromObject:(VideoObject *)video {
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@", video.videoId, SPLIT_SIGN, video.plId, SPLIT_SIGN, video.plName, SPLIT_SIGN, video.videoName, SPLIT_SIGN, video.videoThumbnail, SPLIT_SIGN, video.viewCount];
    return result;
}

- (VideoObject *)getObjectFromString:(NSString *)inputString {
    NSArray *splitArray = [inputString componentsSeparatedByString:SPLIT_SIGN];
    VideoObject *video = [[VideoObject alloc] init];
    video.videoId = [splitArray objectAtIndex:0];
    video.plId = [splitArray objectAtIndex:1];
    video.plName = [splitArray objectAtIndex:2];
    video.videoName = [splitArray objectAtIndex:3];
    video.videoThumbnail = [splitArray objectAtIndex:4];
    video.viewCount = [splitArray objectAtIndex:5];
    return video;
}

- (NSMutableArray *)getFavoriteArray {
    NSMutableArray *favoriteArray = [[NSMutableArray alloc] init];
    NSString *favoriteValues = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_FAVORITE];
    if (favoriteValues && favoriteValues.length > 0) {
        NSArray *splitArray = [favoriteValues componentsSeparatedByString:@"$$"];
        for (NSString *videoString in splitArray) {
            VideoObject *video = [self getObjectFromString:videoString];
            [favoriteArray addObject:video];
        }
    }
    return favoriteArray;
}

- (BOOL)isExistedInFavoriteArrayForObject:(VideoObject *)video {
    NSString *favoriteValues = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_FAVORITE];
    if (!favoriteValues || favoriteValues.length == 0) {
        return NO;
    }
    NSString *inputString = [self makeStringFromObject:video];
    if ([favoriteValues rangeOfString:inputString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (void)removeFavoriteWithObject:(VideoObject *)video {
    // get value from NSUserDefaults
    NSString *favoriteValues = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_FAVORITE];
    if (!favoriteValues || favoriteValues.length == 0) {
        return;
    }
    
    NSString *removedString = [self makeStringFromObject:video];
    // replace with new value
    NSString *newValues = [favoriteValues stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@$$",removedString]
                                                          withString:@""];// is first
    newValues = [newValues stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"$$%@",removedString]
                                                          withString:@""];// or is last
    newValues = [newValues stringByReplacingOccurrencesOfString:removedString
                                                          withString:@""];// or there is just one inside favorite list
    // re-save new value to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:newValues forKey:USERDEFAULT_FAVORITE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addFavoriteWithObject:(VideoObject *)video {
    // get value from NSUserDefaults
    NSString *favoriteValues = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_FAVORITE];
    
    NSString *newValue = [self makeStringFromObject:video];
    if (favoriteValues && favoriteValues.length != 0) {
        newValue = [NSString stringWithFormat:@"%@$$%@",favoriteValues, newValue];
    } else {
        newValue = [NSString stringWithFormat:@"%@", newValue];
    }
    // re-save new value to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:USERDEFAULT_FAVORITE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)checkCategoryAndAnimeIdExistedInDownload:(NSString *)categoryAndAnimeId {
    NSString *downloadValues = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_DOWNLOADED];
    if (!downloadValues || downloadValues.length == 0) {
        return NO;
    }
    if ([downloadValues rangeOfString:categoryAndAnimeId].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (void)addDownloadWithCategoryandAnimeId:(NSString *)categoryAnimeId {
    // get value from NSUserDefaults
    NSString *downloadValues = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_DOWNLOADED];
    
    NSString *newValue = categoryAnimeId;
    if (downloadValues && downloadValues.length != 0) {
        newValue = [NSString stringWithFormat:@"%@$$%@",downloadValues, categoryAnimeId];
    }
    // re-save new value to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:USERDEFAULT_DOWNLOADED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIImage *)getImageWithCategoryAndAnime:(NSString *)categoryAndAnimeName withIndex:(int)index {
    NSString *imagePath = [self.imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@_%d.png", categoryAndAnimeName, categoryAndAnimeName, index]];
    UIImage *imgAvtar = [[UIImage alloc]initWithContentsOfFile:imagePath];
    return imgAvtar;
}

@end
