//
//  ViewController.m
//  HACFacingLog
//
//  Created by macbook on 16/8/3.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "ViewController.h"
#import "HACFacingLogCenter.h"

const int HACFacingLogLocalServerPort = 8080;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dinf(@"bibibi")
    //to log to document directory
    NSString *loggingPath = [documentsPath stringByAppendingPathComponent:@"/mylog.log"];
    NSError *error;
    [@"11" writeToFile:loggingPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    dinf(@"knock knock!");
    [HACFacingLogCenter startServer];
}

@end
