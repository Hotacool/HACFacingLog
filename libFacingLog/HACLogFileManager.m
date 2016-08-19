//
//  HACLogFileManager.m
//  HACFacingLog
//
//  Created by macbook on 16/8/18.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "HACLogFileManager.h"

@implementation HACLogFileManager

+ (void)install {
    //如果已经连接Xcode调试则不输出到文件
    if (isatty(STDOUT_FILENO)) {
        return;
    }

#if TARGET_OS_IPHONE //TARGET_OS_IPHONE
    //将NSLog打印信息保存到Document目录下的Log文件夹下
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:documentsPath];
    if (!fileExists) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error = %@",[error localizedDescription]);
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //每次启动都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [documentsPath stringByAppendingFormat:@"/%@.log",dateStr];
    
    //将log文件输出到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a++", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a++", stderr);
#endif
    
}

+ (NSArray<NSString*>*)getDownloadFiles {
    NSMutableArray *fileArr = [NSMutableArray array];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:documentsPath];
    for (NSString *fileName in enumerator) {
        if ([fileName hasSuffix:@".log"]) {
            [fileArr addObject:fileName];
        }
    }
    return fileArr;
}
@end
