#import <Foundation/Foundation.h>
#import "BlockSessionHandler.h"

@interface APIServices : NSObject <NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>{
    NSMutableArray *arrSessions;
}


#pragma mark registration

#define PREF_APP_TOKEN  @"PREF_APP_TOKEN"
#define NotificationBroadcastDownloadProgress       @"NotificationBroadcastDownloadProgress"

@property (nonatomic,strong) NSString *token;
#pragma mark test 
- (NSMutableURLRequest *)requestWithUrl:(NSString *)url;
- (NSMutableURLRequest *)formRequestWithUrl:(NSString *)url;
- (NSMutableURLRequest*) sendRequestWithURL:(NSString*) aURL
                            queryParam:(NSDictionary*) aQueryParamDict
                             postParam:(NSDictionary*) aPostParamDict
                            httpMethod:(NSString*) aMethod
                                onFail:(void(^)(NSError*)) aFailBlock
                                onDone:(void(^)(NSError* error, id obj)) aDoneBlock;

- (NSMutableURLRequest*) uploadRequestWithURL:(NSString*) aURL
                                   httpMethod:(NSString*) aHttpMethod
                                     andParam:(NSDictionary*) aPostParamDict
                                       onFail:(void(^)(NSError*)) aFailBlock
                                       onDone:(void(^)(NSError* error, id obj)) aDoneBlock;

- (NSDictionary*) sendRequestSyncWithURL:(NSString*) aURL
                                     queryParam:(NSDictionary*) aQueryParamDict
                                      postParam:(NSDictionary*) aPostParamDict
                                     httpMethod:(NSString*) aMethod;

- (BOOL)isNetworkAvailable;
@end
