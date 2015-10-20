//
//  WebAPI.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/12/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIServices.h"

@interface WebAPI : APIServices
+ (WebAPI*)getShared;
- (void)loadConfiguration:(void (^)(NSError* error)) aFailBlock
                   onDone:(void (^)(NSError* error, id obj)) aDoneBlock;
- (void)loadCategoryAndItem:(NSString *)categoryUrl
                     onFail:(void (^)(NSError* error)) aFailBlock
                     onDone:(void (^)(NSError* error, id obj)) aDoneBlock;
@end
