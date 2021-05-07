//
//  Tool.swift
//  TestSDK
//
//  Created by testuser on 2021/5/6.
//

import UIKit

public func sdk_print(_ str: String = "") {
    print("TestSDK：\(str)")
}

public func sdk_Bundle() -> Bundle {
    let bundle = Bundle.init(for: LoadReource.self)
    return bundle
}

//MARK: - 资源加载相关
extension UIImage {
    class func sdk_init(named: String, resource: String = "Resource", type: String = "bundle") -> UIImage? {
        var image: UIImage?
        let bundle = sdk_Bundle()
        if let url = bundle.url(forResource: resource, withExtension: type) {
            let resourceBundle = Bundle.init(url: url)
            image = UIImage.init(named: named, in: resourceBundle, compatibleWith: nil)
        }
        return image
    }
}

extension UINib {
    class func sdk_init(nibName: String) -> UINib? {
        let bundle = sdk_Bundle()
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib
    }
}

extension NSObject
{
    var sdk_className: String{
        get{
          let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }

        }
    }

}
class LoadReource {
    /// 此类用于加载bundle（非main.bundle）
    /// let bundle = Bundle.init(for: LoadReource.self)
    /// let bundle = Bundle.init(for: UIImage.self) ---> main.bundle
}
