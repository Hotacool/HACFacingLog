//
//  ViewController.m
//  HACFacingLog
//
//  Created by macbook on 16/8/3.
//  Copyright © 2016年 silverUp. All rights reserved.
//

#import "ViewController.h"
#import "HACFacingLogCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dinf(@"bibibi")
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    dinf(@"knock knock!");
    [HACFacingLogCenter install];
}

@end
