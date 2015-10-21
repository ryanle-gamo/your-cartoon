//
//  ConfigurationObj.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/12/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface ConfigurationObj : JSONObject
@property (nonatomic, strong) NSString *latest_version;
@property (nonatomic, strong) NSNumber *code;

@property (nonatomic, strong) NSString *category_url;
@property (nonatomic, strong) NSString *file_url;

@property (nonatomic, strong) NSString *admob_banner_id;
@property (nonatomic, strong) NSString *admob_interstitial_id;

@property (nonatomic, strong) NSString *authentication_key;
@property (nonatomic, strong) NSString *channel_id;
@property (nonatomic, strong) NSString *itune_url;
@end
