//
//  NoteEditVC-Config.swift
//  LittlePink
//
//  Created by mac on 2021/10/25.
//

import Foundation

extension NoteEditVC{
    func config(){
        
        hideKeyboardWhenTappedAround()
        
        //collectionview
        photoCollectionview.dragInteractionEnabled = true //开启拖放交互
        
        //titleCountLabel
        titleCountLabel.text = "\(kMaxNoteTitleCount)"
        
        //textView
        //去除文本和placeholder的上下左右边距
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -textView.textContainer.lineFragmentPadding, bottom: 0, right: -textView.textContainer.lineFragmentPadding)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        textView.typingAttributes = typingAttributes
        //光标颜色
        textView.tintColorDidChange()
        //软键盘上的view
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.maxTextCountLabel.text = "/\(kMaxNoteTextCount)"
            
        //MARK: 请求定位权限
        locationManager.requestWhenInUseAuthorization()
        //隐私合规
        
        
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
//        AMapSearchAPI.updatePrivacyShow()
//        AMapSearchAPI
//        参考上面添加隐私
        
        //MARK: 文件相关
        print(NSHomeDirectory()) //沙盒根目录,存文件时不建议直接访问根目录
        //两种寻找文件的方法
        //1.返回路径:NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //2.返回URL:FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        //path为普通字符串,而url一般长这样
        //file:///xxx/xx.mov"(本地)/"https://xx/xx.mov"(远程)
        
        //关于沙盒中的Library/SplashBoard文件夹
        //系统会缓存LaunchScreen.storyboard中的图片,即使删除App也没用,故需手动删除,迭代时需加入代码(可能还需其余优化操作):
//        
    }
}


//MARK: - 监听
extension NoteEditVC{
    @objc private func resignTextView(){
        textView.resignFirstResponder()
    }
}
