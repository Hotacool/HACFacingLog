//
//  HACLog.m
//  HACFacingLog
//
//  Created by macbook on 16/8/4.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "HACLog.h"

@implementation HACLog
+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage {
    HACLog *log = [[HACLog alloc] init];
    
    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        log.timeInterval = timeInterval;
        log.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
    if (sender) {
        log.sender = @(sender);
    }
    
    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
    if (messageText) {
        log.messageText = @(messageText);
    }
    
    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
    if (messageID) {
        log.messageID = [@(messageID) longLongValue];
    }
    
    return log;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[HACLog class]] && self.messageID == [object messageID];
}

- (NSUInteger)hash {
    return (NSUInteger)self.messageID;
}


- (NSString *)displayedTextForLogMessage {
    return [NSString stringWithFormat:@"%@: %@", [self.class logTimeStringFromDate:self.date], self.messageText];
}

+ (NSString *)logTimeStringFromDate:(NSDate *)date {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    
    return [formatter stringFromDate:date];
}
@end
