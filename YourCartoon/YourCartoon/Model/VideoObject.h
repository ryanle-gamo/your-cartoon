//
//  VideoObject.h
//  YoutubePlaylistDemo
//
//  Created by Binh Le on 9/14/15.
//  Copyright (c) 2015 bile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface VideoObject : JSONObject
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *plId;
@property (nonatomic, strong) NSString *plName;
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *videoThumbnail;
@property (nonatomic, strong) NSString *likeCount;
@property (nonatomic, strong) NSString *viewCount;
@property (nonatomic, strong) NSString *videoLink;

+ (NSMutableArray *)arrayFromDictionary:(NSDictionary *)dictionary;

@end
