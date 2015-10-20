//
//  BaseJSONObject.m
//  UrbanDrum
//
//  Created by Quan Do on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONObject.h"
#import <objc/runtime.h>

@interface JSONObject (Private)


-(void) createTable;
-(BOOL) isExistTable:(NSString*) tblName;
@end

@implementation JSONObject

-(void)parseFromJsonData:(NSData*) jsonData {
    NSError *error;
    NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (!error) {
        [self parseFromJsonDictionary:dict];
    }
    else
        NSLog(@"Error: %@",error.debugDescription);
}

-(void)parseFromJsonString:(NSString*) jsonString {
    NSError *error;
    NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        [self parseFromJsonDictionary:dict];
    }
    else
        NSLog(@"Error: %@",error.debugDescription);
}


-(void)parseFromJsonDictionary:(NSDictionary*)jsonDict
{
    if ([jsonDict isKindOfClass:[NSNull class]])
    {
        NSLog(@"EXCEPTION");
        return;
    }
    for(NSString *key in [jsonDict allKeys])
    {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *propName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            if ([propName isKindOfClass:[NSNull class]])
            {
                NSLog(@"EXCEPTION");
                return;
            }
            if([propName isEqualToString:key])
            {
                //NSLog(@" writing value");
                [self setValue:[jsonDict objectForKey:key] forKey:key];
            }
            
        }
        free(properties);
    }
}

-(NSString*) description {
    NSString    *desc = @"";
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        desc = [desc stringByAppendingFormat:@"%@ => %@ \n",propName ,[self valueForKey:propName]];
    }
    free(properties);
    
    return desc;
}

-(NSMutableDictionary*) convertToDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString    *desc = @"";
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [dict setObject:([self valueForKey:propName] && ![[self valueForKey:propName] isKindOfClass:[NSNull class]])?[self valueForKey:propName]:@"" forKey:propName];
        desc = [desc stringByAppendingFormat:@"%@ => %@ \n",propName ,[self valueForKey:propName]?[self valueForKey:propName]:[NSNull null]];
    }
    free(properties);
    
    return dict;
}

-(void) saveToUserPrefWithName:(NSString*) aPrefName {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[self convertToDictionary] forKey:aPrefName];
    [userDefault synchronize];
}

-(void) loadFromUserPrefWithName:(NSString*) aPrefName {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary    *dict = [userDefault objectForKey:aPrefName];
    if (dict) {
        [self parseFromJsonDictionary:dict];
    }
    else
        NSLog(@"Unable to load jSON from User Preference");
}

-(NSString*) toJSONString {
    NSDictionary    *dict = [self convertToDictionary];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSString*) getTableName {
    return [NSString stringWithFormat:@"JSON_%@",NSStringFromClass([self class])];
}

-(NSArray*) getProperties {
    NSMutableArray  *arrPros = [NSMutableArray new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *propType = property_getAttributes(property);
        NSString *propName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString *propertyType = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
        //proceed type
        propertyType = [[propertyType componentsSeparatedByString:@"\""] objectAtIndex:1];
        [arrPros addObject:@{@"type":propertyType,@"name":propName}];
    }
    free(properties);
    
    return [NSArray arrayWithArray:arrPros];
}
@end
