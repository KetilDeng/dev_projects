//
//  Test.swift
//  TestFramework
//
//  Created by testuser on 2021/5/7.
//

import Foundation
import Others
//import Others.Sub
import Vendor
//import Vendor.CFile
//import Vendor.OCFile

public class Test {
    public func hello() {
        print("instance hello world")
    }
}

public func hello() {
    OCTest.test()
    Sub.test()
    Dog.dog()
    print("hello world")
}
