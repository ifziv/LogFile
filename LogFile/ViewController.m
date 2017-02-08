//
//  ViewController.m
//  LogFile
//
//  Created by zivInfo on 17/1/17.
//  Copyright © 2017年 xiwangtech.com. All rights reserved.
//

#import "ViewController.h"

#import "LogFile.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LogFile *file = [LogFile new];
    [file userInfoWithUID:@"aa"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
