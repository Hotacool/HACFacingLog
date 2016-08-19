//
//  HACFacingLogCenter.h
//  HACFacingLog
//
//  Created by macbook on 16/8/3.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import <Foundation/Foundation.h>

//local server setting
static Boolean const HACFacingLogLocalServerExist = YES;
static int const HACFacingLogLocalServerPort = 8081;

@interface HACFacingLogCenter : NSObject

+ (void)install ;
@end
