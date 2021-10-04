//
//  HomeVC.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/9/29.
//

import UIKit
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        //MARK: 设置上方的bar,按钮,条的ui
        
        //1.整体bar--在sb上设置
        
        
        //2.selectedBar--按钮下方条
        settings.style.selectedBarBackgroundColor = UIColor(named: "main")!
        settings.style.selectedBarHeight = 3
        //3.buttonBarItem--文本或按钮
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0
        
        
        super.viewDidLoad()
        
        containerView.bounces = false
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
//        DispatchQueue.main.async {
//            self.moveToViewController(at: 1, animated: false)
//        }//在主线程中执行
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) ->[UIViewController] {
        let followVC = storyboard!.instantiateViewController(withIdentifier: kFollowVCID)
        let nearByVC = storyboard!.instantiateViewController(withIdentifier: kNearByVCID)
        let discoveryVC = storyboard!.instantiateViewController(withIdentifier: kDiscoveryVCID)
        
        return [discoveryVC, followVC, nearByVC]
    }
}
 
