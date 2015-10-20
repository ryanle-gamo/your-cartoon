//
//  BlockSessionHandler.h
//  SHOK
//
//  Created by Quan Do on 18/06/2014.
//  Copyright (c) 2014 Appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockSessionHandler : NSObject

@property (nonatomic,strong) void (^aFailBlock)(NSError *error);
@property (nonatomic,strong) void (^aDoneBlock)(NSError *error, id obj);
@property (nonatomic,strong) NSURLRequest   *urlRequest;
@property (nonatomic,strong) NSURLSession * downloadSession;

+(BlockSessionHandler*) blockSessionWithRequest:(NSURLRequest*) aRequest
                                     andSession:(NSURLSession*) aSession
                                         onFail:(void(^)(NSError*)) aFailBlock
                                         onDone:(void(^)(NSError* error, id obj)) aDoneBlock;
@end

