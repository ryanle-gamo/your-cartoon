//
//  BaseJSONObject.h
//  UrbanDrum
//
//  Created by Quan Do on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONObject : NSObject

-(void)parseFromJsonString:(NSString*) jsonString;
-(void)parseFromJsonData:(NSData*) jsonData;
-(void)parseFromJsonDictionary:(NSDictionary*)jsonDict;
-(NSString*) description;
-(NSMutableDictionary*) convertToDictionary;
-(void) saveToUserPrefWithName:(NSString*) aPrefName;
-(void) loadFromUserPrefWithName:(NSString*) aPrefName;
-(NSString*) toJSONString;
@end
