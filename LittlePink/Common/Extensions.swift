//
//  Extensions.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/10/4.
//

import UIKit
import DateToolsSwift

extension String{
    var isBlank: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String{ //对String？的扩展
    var unwrappedText: String { self ?? "" }
}


extension Date{
    //本项目5种时间表示形式：
    //1.刚刚/5分钟前;2.今天21:10;3.昨天21:10;4.09-15;5.2019-09-15
    var formattedDate: String{
        let currentYear = Date().year
        
        if year == currentYear{//今年
            
            if isToday{//今天
                if minutesAgo > 10{//note发布(或存草稿)超过10分钟则显示'今天xx:xx'
                    return "今天 \(format(with: "HH:mm"))"
                }else{
                    return timeAgoSinceNow
                }
                
            }else if isYesterday{//昨天
                return "昨天 \(format(with: "HH:mm"))"
            }else{//前天或更早的时间
                return format(with: "MM-dd")
            }
            
        }else if year < currentYear{//去年或更早
            return format(with: "yyyy-MM-dd")//y,m,d国际标准
            
        }else{
            return "明年或更远,目前项目还用不到"
        }
    }
    
}

extension UIImage{
    
    //指定构造器必须调用它直接父类的指定构造器方法
    //便利构造器必须调用同一个类中定义的其他初始化方法。
    //便利构造器在最后必须调用一个指定构造器。
    
    convenience init?(_ data: Data?) {
        if let unwrappedData = data{
            self.init(data: unwrappedData)
        }else{
            return nil
        }
    }
    
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    func jpeg(_ jpegQuality: JPEGQuality) -> Data?{
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UITextField {
    var unwrappedText: String { text ?? "" }
    var exactText: String {
        unwrappedText.isBlank ? "" : unwrappedText
    }
}
extension UITextView {
    var unwrappedText: String { text ?? "" }
    var exactText: String {
        unwrappedText.isBlank ? "" : unwrappedText
    }
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
