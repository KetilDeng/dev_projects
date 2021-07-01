//
//  DKTQueueTaskHandler.swift
//  Demo
//
//  Created by testuser on 2021/5/26.
//

import Foundation

//串行队列
let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
//并发队列
let concurrent = DispatchQueue(label: "serial",attributes: .concurrent)
//主队列
let mainQueue = DispatchQueue.main
//全局队列
let global = DispatchQueue.global()
