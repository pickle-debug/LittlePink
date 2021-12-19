//
//  NoteEditVC.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/10/7.
//

import UIKit

class NoteEditVC: UIViewController {
    
    var photos = [
        UIImage(named:"1")!,UIImage(named: "2")!
    ]
    //    var videoURL: URL = Bundle.main.url(forResource: "testvideo", withExtension: ".mp4")!
    var videoURL: URL?
    
    var channel = ""
    var subChannel = ""
    var poiName = ""
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var photoCollectionview: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelPlaceholderLabel: UILabel!
    @IBOutlet weak var poiNameLabel: UILabel!
    @IBOutlet weak var poiNameIcon: UIImageView!
    
    
    var photoCount:Int{ photos.count }
    var isVideo: Bool{videoURL != nil}
    var textViewIAView: TextViewIAView{ (textView.inputAccessoryView as! TextViewIAView) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    @IBAction func TFEditBegin(_ sender: Any) {
        titleCountLabel.isHidden = false
    }
    @IBAction func TFEditEnd(_ sender: Any) {
        titleCountLabel.isHidden = true
    }
    @IBAction func TFEndOnExit(_ sender: Any) {
    }
    @IBAction func TFEditChanged(_ sender: Any) {
        guard titleTextField.markedTextRange == nil else { return }
        if titleTextField.unwarppedText.count > kMaxNoteTitleCount {
            titleTextField.text = String(titleTextField.unwarppedText.prefix(kMaxNoteTitleCount))
            showTextHUD("标题最多可输入\(kMaxNoteTitleCount)字")
            //用户粘贴文本后的光标位置,默认会跑到粘贴文本的前面,此处改为末尾
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        titleCountLabel.text = "\(kMaxNoteTitleCount - titleTextField.unwarppedText.count)"
    }
    
}
    //待做(存草稿和发布笔记前判断当前用户输入的正文文本数量,看是否大于最大可输入量)
    @IBAction func saveDraftNote(_ sender: Any) {
        
    }
    @IBAction func postNote(_ sender: Any) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelVC = segue.destination as? ChannelVC{
            channelVC.PVDelegate = self
        }else if let poiVC = segue.destination as? POIVC{
            poiVC.delegate = self
            poiVC.poiName = poiName
        }
    }
}

extension NoteEditVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
        guard textView.markedTextRange == nil else { return }
        
        textViewIAView.currentTextCount = textView.text.count
    }
}

extension NoteEditVC: ChannelVCDelegate{
    func updateChannel(channel: String, subChannel: String) {
        //数据
        self.channel = channel
        self.subChannel = subChannel
        //UI
        channelIcon.tintColor = blueColor
        channelLabel.text = subChannel
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true

    }
}
//MARK: - POIVCDelegate
extension NoteEditVC: POIVCDelegate{
    func updatePOIName(_ poiName: String) {
        if poiName == kPOIsInitArr[0][0]{
            self.poiName = ""
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }
        else{
            //数据
            self.poiName = poiName
            //UI
            poiNameIcon.tintColor = blueColor
            poiNameLabel.text = poiName
            poiNameLabel.textColor = blueColor
        }
    }
}

//MARK: - 系统自带拼音键盘把拼音也当做字符,故需在输入完后判断,全部移入TFEditChanged方法中处理
//extension NoteEditVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let isExced = range.location >= kMaxNoteTitleCount || (textField.unwarppedText.count + string.count) > kMaxNoteTitleCount
//
//        if isExced {
//            showTextHUD("标题最多可输入\(kMaxNoteTitleCount)字")
//        }
////        if range.location >= kMaxNoteTitleCount || (textField.unwarppedText.count + string.count) > kMaxNoteTitleCount{
////            return false
////        }
//        return !isExced
//    }
//
//}
