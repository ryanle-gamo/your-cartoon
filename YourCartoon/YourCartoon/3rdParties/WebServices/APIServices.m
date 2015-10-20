#import "APIServices.h"

@implementation APIServices

#define RequestTimeOutSeconds 30
#define RUN_ON_MAIN_QUEUE(BLOCK_CODE)           dispatch_async(dispatch_get_main_queue(),(BLOCK_CODE))

-(id) init{
    self = [super init];
    if (self) {
        arrSessions = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark api key store persisent

#pragma mark test 
- (NSMutableURLRequest *)requestWithUrl:(NSString *)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:RequestTimeOutSeconds];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

- (NSMutableURLRequest *)formRequestWithUrl:(NSString *)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:RequestTimeOutSeconds];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forKey:@"Accept"];
    
    return request;
}

#pragma mark HTTP former

- (NSMutableURLRequest *)formUploadRequestWithUrl:(NSString *)url
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:RequestTimeOutSeconds];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
	return request;
}

#pragma mark APIs

- (NSDictionary*) sendRequestSyncWithURL:(NSString*) aURL
                                     queryParam:(NSDictionary*) aQueryParamDict
                                      postParam:(NSDictionary*) aPostParamDict
                                     httpMethod:(NSString*) aMethod {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString    *requestURL = [[NSString alloc] initWithString:aURL];
    // seek for question mark
    BOOL isQuestionMark = ([requestURL rangeOfString:@"?"].location!=NSNotFound)?YES:NO;
    //requestURL = [self authURL:requestURL];
    // process query params
    NSArray *keys = [aQueryParamDict allKeys];
    for (NSString   *key in keys) {
        NSString    *value = [aQueryParamDict objectForKey:key];
        if (value.length !=0) {
            requestURL = [requestURL stringByAppendingFormat:@"%@%@=%@",(isQuestionMark)?@"&":@"?",key,[self percentEscapeString:[aQueryParamDict objectForKey:key]]];
            isQuestionMark = YES;
        }
        
    }
    
    //    __block __weak ASIHTTPRequest  *request = nil;
    NSMutableURLRequest *request = nil;
    
    if ([aMethod isEqualToString:@"GET"]) {
        request = [self requestWithUrl:requestURL];
        
    }
    else
        if ([aMethod isEqualToString:@"POST"]) {
            request = [self formRequestWithUrl:requestURL];
            NSString    *postString = @"";
            keys = [aPostParamDict allKeys];
            for (NSString   *key in keys) {
                //[(ASIFormDataRequest*)request setPostValue:[aPostParamDict objectForKey:key] forKey:key];
                //[request setValue:[aPostParamDict objectForKey:key] forKey:key];
                NSString    *newParam = [NSString stringWithFormat:@"&%@=%@",key,[self percentEscapeString:[aPostParamDict objectForKey:key]]];
                postString = [postString stringByAppendingString:newParam];
            }
            //NSString    *postString = [NSString stringWithFormat:@"tag=&device=%@",[userDefault objectForKey:PREF_PUSH_TOKEN]];
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            NSLog(@"Unsupported method %@",aMethod);
            // safe
            return nil;
        }
    
    
    
    // fetch here
    [request setHTTPMethod:aMethod];
    //[request setValidatesSecureCertificate:NO];
    
    NSError *error = nil;
    NSURLResponse   *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    return [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",urlResponse,@"response",error,@"error", nil];
}

- (NSMutableURLRequest*) sendRequestWithURL:(NSString*) aURL
                                  queryParam:(NSDictionary*) aQueryParamDict
                                   postParam:(NSDictionary*) aPostParamDict
                                  httpMethod:(NSString*) aMethod
                                      onFail:(void(^)(NSError*)) aFailBlock
                                      onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString    *requestURL = [[NSString alloc] initWithString:aURL];
    // seek for question mark
    BOOL isQuestionMark = ([requestURL rangeOfString:@"?"].location!=NSNotFound)?YES:NO;
    //requestURL = [self authURL:requestURL];
    // process query params
    NSArray *keys = [aQueryParamDict allKeys];
    for (NSString   *key in keys) {
        NSString    *value = [aQueryParamDict objectForKey:key];
        if (value.length !=0) {
            requestURL = [requestURL stringByAppendingFormat:@"%@%@=%@",(isQuestionMark)?@"&":@"?",key,[self percentEscapeString:[aQueryParamDict objectForKey:key]]];
            isQuestionMark = YES;
        }

    }
    
//    __block __weak ASIHTTPRequest  *request = nil;
    NSMutableURLRequest *request = nil;
    
    if ([aMethod isEqualToString:@"GET"]) {
        request = [self requestWithUrl:requestURL];
        
    }
    else
        //if ([aMethod isEqualToString:@"POST"])
        {
            request = [self formRequestWithUrl:requestURL];
            NSString    *postString = @"";
            keys = [aPostParamDict allKeys];
            for (NSString   *key in keys) {
                //[(ASIFormDataRequest*)request setPostValue:[aPostParamDict objectForKey:key] forKey:key];
                //[request setValue:[aPostParamDict objectForKey:key] forKey:key];
                NSString    *newParam = [NSString stringWithFormat:@"&%@=%@",key,[self percentEscapeString:[aPostParamDict objectForKey:key]]];
                postString = [postString stringByAppendingString:newParam];
            }
            //NSString    *postString = [NSString stringWithFormat:@"tag=&device=%@",[userDefault objectForKey:PREF_PUSH_TOKEN]];
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        }
//        else
//        {
//            DLog(@"Unsupported method %@",aMethod);
//            // safe
//            return nil;
//        }
    
    
    
    // fetch here
    [request setHTTPMethod:aMethod];
    //[request setValidatesSecureCertificate:NO];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                             RUN_ON_MAIN_QUEUE(^{
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                             });

                             if (connectionError) {
                                 aFailBlock(connectionError);
                             }
                             else {
                                 aDoneBlock(connectionError,data);
                             }
                         }];
    return request;

    
}

- (NSMutableURLRequest*) uploadRequestWithURL:(NSString*) aURL
                                   httpMethod:(NSString*) aHttpMethod
                                     andParam:(NSDictionary*) aPostParamDict
                                       onFail:(void(^)(NSError*)) aFailBlock
                                       onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableURLRequest *request = [self formUploadRequestWithUrl:aURL];
    NSString *boundary = @"0xKhTmLbOuNdArY"; // This is important! //NSURLConnection is very sensitive to format.
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPMethod:aHttpMethod];
    
    NSArray *arrKeys = aPostParamDict.allKeys;
    
    NSMutableData *body = [NSMutableData data];
    // frirst boundary
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // scan
    for (int i = 0; i < arrKeys.count; i++) {
        NSString    *key = [arrKeys objectAtIndex:i];
        NSObject    *obj = [aPostParamDict objectForKey:key];
        NSData  *preData = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *postStrTmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            // process string
            [body appendData:[postStrTmp dataUsingEncoding:NSUTF8StringEncoding]];
            preData = [(NSString*)obj dataUsingEncoding:NSUTF8StringEncoding];
            [body appendData:preData];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    for (int i = 0; i < arrKeys.count; i++) {
        NSString    *key = [arrKeys objectAtIndex:i];
        NSObject    *obj = [aPostParamDict objectForKey:key];
        NSData  *preData = nil;
        if ([obj isKindOfClass:[NSString class]]) {

        }
        else {
            // add
            NSString *postStrTmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",key,key];
            [body appendData:[postStrTmp dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            // it can be image or data
//            UIImage *tmpImg;
            if ([obj isKindOfClass:[UIImage class]]) {

                // check for size
//                tmpImg = (UIImage*)obj;
//                if (tmpImg.size.width > 1280) {
//                    tmpImg = [tmpImg resizedImageToFitInSize:CGSizeMake(1280, 99999) preferedWidth:YES];
//                    
//                }
                preData=UIImageJPEGRepresentation((UIImage*)obj, 0.5);
            }
            else {
                // if it is raw data, just let it go thru
                // it must data
                preData = (NSData*)obj;
            }
            

            
            [body appendData:[NSData dataWithData:preData]];
            // lock
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    if (arrKeys.count == 0) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [request setHTTPBody:body];
    
    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               RUN_ON_MAIN_QUEUE(^{
//                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//                               });
//
//                               //DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                               if (connectionError) {
//                                   aFailBlock(connectionError);
//                               }
//                               else {
//                                   aDoneBlock(connectionError,data);
//                               }
//                           }];
    
    NSDateFormatter *formater = [NSDateFormatter new];
    [formater setDateFormat:@"yyyy-MM-dd-hh-mm-ss-SSS"];
    NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:[formater stringFromDate:[NSDate date]]];
    NSURLSession *backgoundSession = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    // create block session handler
    BlockSessionHandler *blockSession = [BlockSessionHandler blockSessionWithRequest:request andSession:backgoundSession onFail:aFailBlock onDone:aDoneBlock];
    
    // add to block handler
    [arrSessions addObject:blockSession];
    
    NSURLSessionDownloadTask * downloadTask =[ backgoundSession downloadTaskWithRequest:request];
    
    [downloadTask resume];
    
    return request;
}

#pragma mark utilities
- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

#pragma mark    BACKGROUND HANDLER FOR NETWORKING

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    for (BlockSessionHandler *blockSession in arrSessions) {
        if ([blockSession.downloadSession isEqual:session]) {
            // proceed
            // read the file
            NSData  *data = [[NSData alloc] initWithContentsOfURL:location];
            // pass to done
            blockSession.aDoneBlock(nil,data);
            
            // remove block session
            [arrSessions removeObject:blockSession];
            break;
        }
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
//    dispatch_async(dispatch_get_main_queue(),^ {
//        [self.progress setProgress:progress animated:YES];
//    });
    
    // broad casting
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationBroadcastDownloadProgress object:@{@"session":session,@"task":downloadTask,@"progress":[NSNumber numberWithFloat:progress]}];
    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
}


/*
 ###################### Download Task END
 */

/*
 ###################### Data Task  Start
 */


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"### handler 2");
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"### handler 1");
    
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String %@",str);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        NSLog(@"Download is Succesfull");
    }
    else {
        NSLog(@"Error %@",[error userInfo]);
        for (BlockSessionHandler *blockSession in arrSessions) {
            if ([blockSession.downloadSession isEqual:session]) {
                // proceed
                // pass to error
                blockSession.aFailBlock(error);
                
                // remove block session
                [arrSessions removeObject:blockSession];
                break;
            }
        }
    }
}

- (BOOL)isNetworkAvailable
{
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"http://www.google.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
        NSLog (@"Connection is down");
        return NO;
    }
}

@end
