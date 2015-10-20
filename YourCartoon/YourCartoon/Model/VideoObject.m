//
//  VideoObject.m
//  YoutubePlaylistDemo
//
//  Created by Binh Le on 9/14/15.
//  Copyright (c) 2015 bile. All rights reserved.
//

#import "VideoObject.h"
#include <stdlib.h>

#define RANDOM_MAX 2000000
#define RANDOM_MIN 500000
@implementation VideoObject

+ (NSMutableArray *)arrayFromDictionary:(NSDictionary *)dictionary {
    NSMutableArray *dictionary1 = [dictionary valueForKeyPath:@"items.snippet"];
    NSMutableArray *videos = [NSMutableArray array];
    for (NSDictionary *item in dictionary1) {
        VideoObject *videoObject = [[VideoObject alloc] init];
        [videoObject parser:item];
        [videos addObject:videoObject];
    }
    
    return videos;
}

- (void) parser:(id) json {
    self.videoName = [json valueForKey:@"title"];
    self.plId = [json valueForKey:@"playlistId"];
    NSDictionary *resourceDictionary = [json valueForKeyPath:@"resourceId"];
    self.videoId = [resourceDictionary valueForKey:@"videoId"];
    self.videoLink = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", self.videoId];
    self.viewCount = [self getRandomViewCount];
    NSDictionary *thumbnailDictionary = [json valueForKeyPath:@"thumbnails.medium"];
    self.videoThumbnail = [thumbnailDictionary valueForKey:@"url"];
}

- (NSString *)getRandomViewCount {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSNumber *number = [[NSNumber alloc] initWithInt:RANDOM_MIN + rand() % (RANDOM_MAX - RANDOM_MIN)];
    return [numberFormatter stringFromNumber:number];
}

@end
