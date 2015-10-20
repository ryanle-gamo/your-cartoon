//
//  BlockSessionHandler.m
//  SHOK
//
//  Created by Quan Do on 18/06/2014.
//  Copyright (c) 2014 Appiphany. All rights reserved.
//

#import "BlockSessionHandler.h"

@implementation BlockSessionHandler

+(BlockSessionHandler*) blockSessionWithRequest:(NSURLRequest*) aRequest
                                     andSession:(NSURLSession*) aSession
                                         onFail:(void(^)(NSError*)) aFailBlock
                                         onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
    BlockSessionHandler *blockSession = [BlockSessionHandler new];
    blockSession.aFailBlock = aFailBlock;
    blockSession.aDoneBlock = aDoneBlock;
    blockSession.urlRequest = aRequest;
    blockSession.downloadSession = aSession;
    
    return blockSession;
}
@end
