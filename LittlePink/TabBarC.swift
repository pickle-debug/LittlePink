//
//  TabBarC.swift
//  Pods
//
//  Created by 何纪栋 on 2021/10/4.
//

import UIKit
import YPImagePicker

class TabBarC: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostVC{
            
            //TO DO login\register
            
            var config = YPImagePickerConfiguration()
            
            //MARK: -通用配置
            config.isScrollToChangeModesEnabled = false
            config.onlySquareImagesFromCamera = false
            config.albumName = Bundle.main.appName
            config.startOnScreen = .library
            config.screens = [.library, .video, .photo]
            config.maxCameraZoomFactor = kMaxCameraZoomFactor
            
            //照片视频不能混排，多选视频会合成一个视频，编辑页可追加视频或照片，笔记允许发布多张照片或者单个视频
            
            //MARK: -相册配置
            config.library.defaultMultipleSelection = true
            config.library.maxNumberOfItems = kMaxPhotoCounts
            config.library.spacingBetweenItems = kSpacingBetweenItems
            config.library.skipSelectionsGallery = false
            
            //MARK: -视频配置 all default
            
            //MARK: -画廊配置(多选后的照片廊)
            config.gallery.hidesRemoveButton = false

           
            let picker = YPImagePicker(configuration: config)
            
            //MARK: -选完后或按取消按钮后的异步回调处理（依据配置处理单个或多个）
            picker.didFinishPicking { [unowned picker] items, cancelled in
                if cancelled {
                    print("用户按了左上角的取消")
                }
                for item in items {
                    switch item {
                    case let .photo(photo):
                        print(photo)
                    case .video(let video):
                        print(video)
                    }
                }
                
                picker.dismiss(animated: true)
            }
            present(picker, animated: true)

            
            return false
        }
            return true
    }
}
