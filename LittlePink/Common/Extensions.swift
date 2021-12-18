//
//  Extensions.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/10/4.
//

import UIKit

extension String{
    var isBlank: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String{ //对String？的扩展
    var unwrappedText: String { self ?? "" }
    
}

extension UITextField {
    var unwarppedText: String { text ?? "" }
}

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
    func showLoadHUD(_ title: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
    }
    func hideLoadHUD(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    // MARK: 提示框--自动隐藏
    func showTextHUD(_ title:String, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
        
    }
    
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
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
    
    //static能修饰class/struct/enum的计算属性,存储属性,类型方法;class能修饰类的计算属性和方法
    //static修饰的类方法不能继承,class修饰的类方法可以继承
    //在protocol中要使用static
    
    static func loadView<T>(fromNib name: String, with type: T.Type) -> T{ //<T>泛型 static 静态方法
        if let view = Bundle.main.loadNibNamed(name , owner: nil, options: nil)?.first as? T{
            return view
        }
        fatalError("加载\(type)类型的view失败了")
    }
}
