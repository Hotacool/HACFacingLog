//
//  HACFacingLogCenter.m
//  HACFacingLog
//
//  Created by macbook on 16/8/3.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "HACFacingLogCenter.h"
#import "HACLogServer.h"
#import "HACLogFileManager.h"

@interface HACFacingLogCenter()

@end

@implementation HACFacingLogCenter

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static HACFacingLogCenter *instance;
    dispatch_once(&onceToken, ^{
        instance = [[HACFacingLogCenter alloc] init];
    });
    return instance;
}

+ (void)install {
    //local server
    if (HACFacingLogLocalServerExist) {
        [HACLogServer startServerWithPort:HACFacingLogLocalServerPort];
    }
    
    [HACLogFileManager install];
}


@end
