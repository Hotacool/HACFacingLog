//
//  HACLogFileManager.h
//  HACFacingLog
//
//  Created by macbook on 16/8/18.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACLogFileManager : NSObject

+ (void)install ;

+ (NSArray<NSString*>*)getDownloadFiles ;
@end
