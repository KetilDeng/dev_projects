//
//  ViewController.m
//  OCTestDemo
//
//  Created by testuser on 2021/4/7.
//

#import "ViewController.h"
#import <TestSDK/TestSDK-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"-----[ViewController viewDidLoad]");
    [[TestKit share] getHomeVC];
    
}


@end
