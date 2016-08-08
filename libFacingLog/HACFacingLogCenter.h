//
//  HACFacingLogCenter.h
//  HACFacingLog
//
//  Created by macbook on 16/8/3.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern Boolean const HACFacingLogLocalServerExist;
extern int const HACFacingLogLocalServerPort;

@interface HACFacingLogCenter : NSObject

+ (void)startServer ;

+ (void)stopServer ;
@end
