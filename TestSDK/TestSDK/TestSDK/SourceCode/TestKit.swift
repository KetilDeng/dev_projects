//
//  TestKit.swift
//  TestSDK
//
//  Created by testuser on 2021/5/6.
//

import UIKit

class TestKit {
    
    //APP启动初始化
    public class func initTestKit(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ///初始化相关
        sdk_print("TestSDK初始化成功")
    }
    
    //获取一个控制器
    public class func getHomeVC() -> UIViewController {
        sdk_print("获取首页")
        let vc = HomeVC()
        return vc
    }
}
