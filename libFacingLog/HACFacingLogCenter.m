//
//  HACFacingLogCenter.m
//  HACFacingLog
//
//  Created by macbook on 16/8/3.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "HACFacingLogCenter.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerFileResponse.h"
#import "HACLogManager.h"

static NSString *const HACUrlPath_logAll = @"/";
static NSString *const HACUrlPath_logAfterTime = @"/log";
static NSString *const HACUrlPath_logAfterTime_queryParam = @"after";
static NSString *const HACUrlPath_logDownload = @"/download";
static NSString *const HACUrlPath_logDownload_queryParam = @"name";
static NSString *const HACUrlPath_logDeleteBeforeTime = @"/delete";

@interface HACFacingLogCenter()
@property (nonatomic, strong) GCDWebServer* webServer;
@property (nonatomic, assign) NSTimeInterval timeRecord;

@end

@implementation HACFacingLogCenter

SB_ARC_SINGLETON_IMPLEMENT(HACFacingLogCenter)

+ (void)startServer {
    if ([[self sharedHACFacingLogCenter].webServer isRunning]) {
        derr(@"local server has been already runing. you can visit at url: %@",[self sharedHACFacingLogCenter].webServer.serverURL);
        return;
    }
    [[self sharedHACFacingLogCenter].webServer startWithPort:HACFacingLogLocalServerPort bonjourName:nil];
}

+ (void)stopServer {
    [[self sharedHACFacingLogCenter].webServer stop];
    [self sharedHACFacingLogCenter].webServer = nil;
}

#pragma mark -- instance method
- (GCDWebServer *)webServer {
    if (!_webServer) {
        _webServer = [[GCDWebServer alloc] init];
        SBWS(weakSelf)
        // Add a handler to respond to GET requests on any URL
        [_webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      return [weakSelf createResponseBody:request];
                                  }];
        NSLog(@"Visit %@ in your web browser", _webServer.serverURL);
    }
    return _webServer;
}

- (GCDWebServerResponse *)createResponseBody :(GCDWebServerRequest* )request {
    GCDWebServerResponse *response = nil;
    NSMutableString* string = [[NSMutableString alloc] init];;
    NSString* path = request.path;
    NSDictionary* query = request.query;
    if ([path isEqualToString:HACUrlPath_logAll]) {
        [self _appendLogRecordsToString:string afterAbsoluteTime:0.0];
        NSDictionary *dic = @{@"PRODUCT":[NSString stringWithCString:getprogname() encoding:NSUTF8StringEncoding]
                              ,@"CONTENT":string};
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"logTemplete" ofType:@"html"];
        response = [GCDWebServerDataResponse responseWithHTMLTemplate:filePath variables:dic];
    } else if ([path isEqualToString:HACUrlPath_logAfterTime] && query[HACUrlPath_logAfterTime_queryParam]) {
        double time = [query[HACUrlPath_logAfterTime_queryParam] doubleValue];
        [self _appendLogRecordsToString:string afterAbsoluteTime:time];
        response = [GCDWebServerDataResponse responseWithHTML:string];
    } else if ([path isEqualToString:HACUrlPath_logDownload]) {
        if (query[HACUrlPath_logDownload_queryParam]) {
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"/mylog.log"];
            NSString* fileType = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL] fileType];
            if (fileType) {
                if ([fileType isEqualToString:NSFileTypeRegular]) {
                    // always allow ranges in our requests
                    response = [GCDWebServerFileResponse responseWithFile:filePath byteRange:request.byteRange];
                    [response setValue:@"bytes" forAdditionalHeader:@"Accept-Ranges"];
                }
            }
        } else {
            [self _appendLogFileToString:string];
            NSDictionary *dic = @{@"PRODUCT":[NSString stringWithCString:getprogname() encoding:NSUTF8StringEncoding]
                                  ,@"CONTENT":string};
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"download" ofType:@"html"];
            response = [GCDWebServerDataResponse responseWithHTMLTemplate:filePath variables:dic];
        }
    } else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
        response = [GCDWebServerDataResponse responseWithHTMLTemplate:filePath variables:nil];
    }
    return response;
}

- (void)_appendLogRecordsToString:(NSMutableString*)string afterAbsoluteTime:(double)time {
    __block double maxTime = time;
    NSArray<HACLog *>  *allMsg = [HACLogManager queryLogByTime:time];
    [allMsg enumerateObjectsUsingBlock:^(HACLog * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const char* style = "color: dimgray;";
        NSString* formattedMessage = [self displayedTextForLogMessage:obj];
        [string appendFormat:@"<tr style=\"%s\">%@</tr>", style, formattedMessage];
        if (obj.timeInterval > maxTime) {
            maxTime = obj.timeInterval ;
        }
    }];
    self.timeRecord = maxTime;
    [string appendFormat:@"<tr id=\"maxTime\" data-value=\"%f\"></tr>", maxTime];
    
}

- (NSString *)displayedTextForLogMessage:(HACLog *)msg{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<td>%@</td> <td>%@</td> <td>%@</td>",[HACLog logTimeStringFromDate:msg.date ],msg.sender, msg.messageText];
    return string;
}

- (void)_appendLogFileToString:(NSMutableString*)string {
    NSArray *fileNames = [self getDownloadFiles];
    [fileNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const char* style = "color: dimgray;";
        [string appendFormat:@"<tr style=\"%s\"><a href=\"/download?name=%@\">%@</a></tr>", style, obj, obj];
    }];
}



- (NSArray<NSString*>*)getDownloadFiles {
    NSMutableArray *fileArr = [NSMutableArray array];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:documentsPath];
    for (NSString *fileName in enumerator) {
        [fileArr addObject:fileName];
    }
    return fileArr;
}
@end
