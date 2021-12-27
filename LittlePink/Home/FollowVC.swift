//
//  FollowVC.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/9/29.
//

import UIKit
import XLPagerTabStrip

class FollowVC: UIViewController, IndicatorInfoProvider{

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = ColorBtn(frame: CGRect(x: 100, y: 100, width: 100, height: 100), color: .green)
        view.addSubview(btn)
        // Do any additional setup after loading the view.
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("Follow", comment: "首页上方的关注标签"))
    }
}
class ColorBtn: UIButton{
    var color: UIColor //自己的属性
    init(frame: CGRect, color: UIColor) { //在自己的初始化方法里先初始化
        self.color = color//先给自己的属性赋值
        super.init(frame: frame)//在父类里初始化，后给父类的属性赋上值
        backgroundColor = color//继承属性
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
}
