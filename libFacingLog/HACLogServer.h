//
//  HACLogServer.h
//  HACFacingLog
//
//  Created by macbook on 16/8/18.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACLogServer : NSObject
+ (void)startServerWithPort:(NSInteger)port ;

+ (void)stopServer ;
@end
