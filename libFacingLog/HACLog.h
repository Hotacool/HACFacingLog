//
//  HACLog.h
//  HACFacingLog
//
//  Created by macbook on 16/8/4.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "asl.h"

@interface HACLog : NSObject
+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, assign) long long messageID;



- (NSString *)displayedTextForLogMessage;
+ (NSString *)logTimeStringFromDate:(NSDate *)date;
@end
