//
//  TestObjKit.m
//  TestSDK
//
//  Created by testuser on 2021/7/13.
//

#import "TestObjKit.h"
#import <TestSDK/TestSDK-Swift.h>
#import <JPush/JPUSHService.h>
@implementation TestObjKit

+ (void)initKit {
    NSLog(@"SDK初始化");
    [JPUSHService setupWithOption:@{} appKey:@"" channel:@"" apsForProduction:false];
}

+ (UIViewController *)getHomeVC {
    NSLog(@"获取首页");
    HomeVC *vc = [HomeVC new];
    return vc;
}
@end
