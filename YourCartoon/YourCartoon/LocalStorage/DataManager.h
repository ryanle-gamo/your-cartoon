//
//  DataManager.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/13/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoObject;
@interface DataManager : NSObject
@property (nonatomic, strong) NSString *imagePath;
+ (instancetype)getSharedInstance;

/*  FAVORITE PROCESSING  */
- (NSMutableArray *)getFavoriteArray;
- (BOOL)isExistedInFavoriteArrayForObject:(VideoObject *)video;
- (void)removeFavoriteWithObject:(VideoObject *)video;
- (void)addFavoriteWithObject:(VideoObject *)video;
- (NSString *)makeStringFromObject:(VideoObject *)video;
- (VideoObject *)getObjectFromString:(NSString *)inputString;

/* DOWNLOADING STORAGE */
- (BOOL)checkCategoryAndAnimeIdExistedInDownload:(NSString *)categoryAndAnimeId;
- (void)addDownloadWithCategoryandAnimeId:(NSString *)categoryAnimeId;

- (UIImage *)getImageWithCategoryAndAnime:(NSString *)categoryAndAnimeName withIndex:(int)index;
@end
