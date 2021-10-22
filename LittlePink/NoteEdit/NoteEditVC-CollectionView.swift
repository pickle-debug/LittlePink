//
//  NoteEditVC-CollectionView.swift
//  LittlePink
//
//  Created by mac on 2021/10/22.
//

import YPImagePicker
import SKPhotoBrowser
import AVKit

extension NoteEditVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoCell
        
        cell.imageView.image = photos[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
            photoFooter.addPhotoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            return photoFooter
        default:
            fatalError("collectionView的footer出问题")
        }
    }
}

extension NoteEditVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isVideo {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: videoURL!)
            present(playerVC, animated: true){
                playerVC.player?.play()
            }
        } else {
            // 1. create SKPhoto Array from UIImage
            var images: [SKPhoto] = []
            
            for photo in photos{
                images.append(SKPhoto.photoWithImage(photo))
            }
            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.item)
            browser.delegate = self
            SKPhotoBrowserOptions.displayAction = false
            SKPhotoBrowserOptions.displayDeleteButton = true
            present(browser, animated: true)

        }

    }
}
// MARK: - SKPhotoBrowserDelegate
extension NoteEditVC:SKPhotoBrowserDelegate{
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        photoCollectionview.reloadData()
        reload()
    }
    
}

//MARK: - 监听
extension NoteEditVC{
    @objc private func addPhoto(){
        if photoCount < kMaxPhotoCounts {
            var config = YPImagePickerConfiguration()
            
            //MARK: -通用配置
            config.albumName = Bundle.main.appName
            config.screens = [.library]
            
            //照片视频不能混排，多选视频会合成一个视频，编辑页可追加视频或照片，笔记允许发布多张照片或者单个视频
            
            //MARK: -相册配置
            config.library.defaultMultipleSelection = true
            config.library.maxNumberOfItems = kMaxPhotoCounts - photoCount
            config.library.spacingBetweenItems = kSpacingBetweenItems
            
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
                if case let .photo(photo) = item {
                    self.photos.append(photo.image)
                }
            }
                self.photoCollectionview.reloadData()

                picker.dismiss(animated: true)
            }
            present(picker, animated: true)
            
        } else {
            
            self.showTextHUD("最多只能选择\(kMaxPhotoCounts)张照片哦")
        }
    }
}
