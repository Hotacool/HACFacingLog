//
//  HACLogManager.m
//  HACFacingLog
//
//  Created by macbook on 16/8/4.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "HACLogManager.h"

@implementation HACLogManager

+ (NSArray<HACLog *> *)queryLogByTime:(NSTimeInterval)timeInterval {
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    NSString *pidString = [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
    NSString *time = [NSString stringWithFormat:@"%d", (int)timeInterval];
    asl_set_query(query, ASL_KEY_PID, [pidString UTF8String], ASL_QUERY_OP_EQUAL);
    //尽量添加search条件，减少result时间
    if (timeInterval>0) {
        //ASL_KEY_TIME只能精确到秒
        asl_set_query(query, ASL_KEY_TIME, [time cStringUsingEncoding:NSASCIIStringEncoding], ASL_QUERY_OP_GREATER_EQUAL | ASL_QUERY_OP_NUMERIC);
    }
    aslmsg aslMessage = NULL;
    aslresponse response = asl_search(NULL, query);
    NSMutableArray *logArray = [NSMutableArray array];
    while ((aslMessage = asl_next(response))) {
        //处理秒以下重复数据
        HACLog *tmp = [HACLog logMessageFromASLMessage:aslMessage];
        if (tmp.timeInterval>timeInterval) {
            [logArray addObject:tmp];
        }
    }
    asl_release(response);
    return logArray;
}
@end
