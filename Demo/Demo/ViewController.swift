//
//  ViewController.swift
//  Demo
//
//  Created by testuser on 2021/5/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        //串行队列+同步任务——依次执行
//        let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
//        for i in 0...10 {
//            serial.sync {
//                sleep(arc4random()%3)//休眠时间随机
//                print(i)
//            }
//            print("-----\(i)--------")
//        }
//
        
        
        //串行队列+异步任务——开启一个新线程依次执行
//        let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
//        print(Thread.current)//主线程
//        for i in 0...10 {
//            serial.async {
//                sleep(arc4random()%3)//休眠时间随机
//                print(i,Thread.current)//子线程
//            }
//        }
        
        
//        并发队列+同步任务——依次执行
//        for i in 0...10 {
//            DispatchQueue.global().sync {
//                sleep(arc4random()%3)//休眠时间随机
//                print(i,Thread.current)
//            }
//        }

        
//        并发队列+异步任务——开启多个线程并发执行

//        for i in 0...10 {
//            DispatchQueue.global().async {
//                sleep(arc4random()%3)//休眠时间随机
//                print(i,Thread.current)
//            }
//        }
        
        
        
//        并发队列——最大并发数
//        GCD并不能无限制的创建线程，如下代码其实最多创建64个子线程，意味着最大并发数为64。
//        for i in 0...1000 {
//             DispatchQueue.global().async {
//                 print(i,Thread.current)
//                 sleep(10000)
//             }
//         }
        
        
        //GCD 栅栏
//        for i in 0...10 {
//            DispatchQueue.global().async {
//                print(i)
//            }
//        }
//        DispatchQueue.global().async(flags: .barrier) {
//            print("this is barrier")
//        }
//        for i in 11...20 {
//            DispatchQueue.global().async {
//                print(i)
//            }
//        }
        
        
        
        //GCD group
//        let group = DispatchGroup()
//        for i in 0...10 {
//            DispatchQueue.global().async(group: group) {
//                sleep(arc4random()%3)//休眠时间随机
//                print(i)
//            }
//        }
//        //queue参数表示以下任务添加到的队列
//        group.notify(queue: DispatchQueue.main) {
//            print("group 任务执行结束")
//        }
        
        
        //使用wait进行等待——可定义超时
        let group = DispatchGroup()
         for i in 0...10 {
             DispatchQueue.global().async(group: group) {
                 sleep(arc4random()%10)//休眠时间随机
                 print(i)
             }
         }
         switch group.wait(timeout: DispatchTime.now()+5) {
         case .success:
             print("group 任务执行结束")
         case .timedOut:
             print("group 任务执行超时")
         }
        
        print("1111111111111111")

    }


}

