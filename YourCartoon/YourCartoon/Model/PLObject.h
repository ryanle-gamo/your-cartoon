//
//  PLObject.h
//  YoutubePlaylistDemo
//
//  Created by Binh Le on 9/14/15.
//  Copyright (c) 2015 bile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface PLObject : JSONObject
@property (nonatomic, strong) NSString *plId;
@property (nonatomic, strong) NSString *plName;
@property (nonatomic, strong) NSMutableArray *videoArray;

+ (NSMutableArray *)arrayFromDictionary:(NSDictionary *)dictionary;

@end
