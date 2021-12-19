//
//  POIVC.swift
//  LittlePink
//
//  Created by mac on 2021/10/28.
//

import UIKit


//http链接问题，没法再次查询，同时查询很慢
//搜索POI存在问题
//👆🏻已解决,info.plist添加
class POIVC: UIViewController {
    
    var delegate: POIVCDelegate?
    var poiName = ""
    
    lazy var locationManager = AMapLocationManager()
    lazy var mapSearch = AMapSearchAPI()
    lazy var aroundSearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
                
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.requireExtension = true
        request.offset = kPOIsOffset
        return request
    }()
    
    lazy var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keywords
        request.requireExtension = true
        return request
    }()
    lazy var footer = MJRefreshAutoNormalFooter()
    
    //因页面一开始在cell中有数组取值处理，必须规定内嵌的数组有两个元素，若元素数量动态的话可用下面的repeating方法
    //    var pois = [Array(repeating: "", count: 2)]
    var pois = kPOIsInitArr
    var aroundSearchPOIs = kPOIsInitArr //完全同步copy周边的pois数组，用于简化逻辑
    var latitude = 0.0
    var longitude = 0.0
    var keywords = ""
    var currentAroundPage = 1
    var currentKeywordsPage = 1
    var pageCount = 1
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        requestLocation()
    }

}
//MARK: - UITableViewDataSource
extension POIVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { pois.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPOICellID, for: indexPath) as! POICell
        
        let poi = pois[indexPath.row]
        cell.poi = poi
        
        if poi[0] == poiName{ cell.accessoryType = .checkmark }
        return cell
    }
}
extension POIVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        //反向传值
        delegate?.updatePOIName(pois[indexPath.row][0])
        
        dismiss(animated: true)
    }
}

extension POIVC{
    func endRefreshing(_ currentPage: Int){
        if currentPage < pageCount{
            footer.endRefreshing() //结束上拉加载小菊花的UI
        }else{
            footer.endRefreshingWithNoMoreData()//展示加载完毕UI,并使上拉加载功能失效(不触发@objc的方法)
        }
    }
}
