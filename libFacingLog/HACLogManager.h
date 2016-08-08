//
//  HACLogManager.h
//  HACFacingLog
//
//  Created by macbook on 16/8/4.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HACLog.h"

@interface HACLogManager : NSObject

+ (NSArray<HACLog*>*)queryLogByTime:(NSTimeInterval)timeInterval ;
@end
