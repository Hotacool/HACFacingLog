//
//  ViewController.m
//  TestHACF
//
//  Created by macbook on 16/8/19.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "ViewController.h"
#import <HACFacingLogFwk/HACFacingLogFwk.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static int count = 0;
- (IBAction)ClickMe:(id)sender {
    NSLog(@"button click!");
    if (!count++) {
        [HACFacingLogCenter install];
    }
}

@end
