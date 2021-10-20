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

extension UIViewController {
    
    // MARK: - 显示加载框或提示框
    
    // MARK: 加载框--手动隐藏
    // MARK: 提示框--自动隐藏
    func showTextHUD(_ title:String, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
        
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
