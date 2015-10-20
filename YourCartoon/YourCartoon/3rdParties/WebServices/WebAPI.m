//
//  WebAPI.m
//  HowToMakeClay
//
//  Created by Binh Le on 7/12/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "WebAPI.h"

@implementation WebAPI


static WebAPI   *singleton;

- (id)init {
    self = [super init];
    if (self) {
        singleton = self;
    }
    
    return self;
}

+ (WebAPI*)getShared {
    if (singleton) {
        return singleton;
    }
    else
        return [[WebAPI alloc] init];
}

- (void)loadConfiguration:(void (^)(NSError *))aFailBlock
                   onDone:(void (^)(NSError *, id))aDoneBlock {
    [self sendRequestWithURL:URL_CONFIGURATION queryParam:nil postParam:nil httpMethod:@"GET" onFail:aFailBlock onDone:aDoneBlock];
}

- (void)loadCategoryAndItem:(NSString *)categoryUrl
                     onFail:(void (^)(NSError *))aFailBlock
                     onDone:(void (^)(NSError *, id))aDoneBlock {
    [self sendRequestWithURL:categoryUrl queryParam:nil postParam:nil httpMethod:@"GET" onFail:aFailBlock onDone:aDoneBlock];
}

@end
