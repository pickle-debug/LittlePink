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
    var videoURL: URL?
//    var videoURL: URL = Bundle.main.url(forResource: "testvideo", withExtension: ".mp4")!
    
    
    @IBOutlet weak var photoCollectionview: UICollectionView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    var photoCount:Int{ photos.count }
    var isVideo: Bool{videoURL != nil}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionview.dragInteractionEnabled = true //开启拖放交互
    }
    
    @IBAction func TFEditBegin(_ sender: Any) {
        titleCountLabel.isHidden = false
    }
    @IBAction func TFEditEnd(_ sender: Any) {
        titleCountLabel.isHidden = true
    }
    
}
