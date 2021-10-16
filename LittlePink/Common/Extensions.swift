//
//  Extensions.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/10/4.
//

import UIKit

extension UIView{
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}


extension Bundle{
    var appName: String{
        if let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as?
            String{
                return appName
            } else {
                return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
            }
    }
}
