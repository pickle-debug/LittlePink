//
//  POIVC.swift
//  LittlePink
//
//  Created by mac on 2021/10/28.
//

import UIKit


//http链接问题，没法再次查询，同时查询很慢
//搜索POI存在问题
class POIVC: UIViewController {
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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        requestLocation()
        
        mapSearch?.delegate = self
    }

}

extension POIVC: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { dismiss(animated: true) }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            pois = aroundSearchPOIs
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.isBlank else { return }
                keywords = searchText
                pois.removeAll()
                showLoadHUD()
                keywordsSearchRequest.keywords = keywords
                mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }
}

//MARK: - 所有搜索POI的回调-AMapSearchDelegate
extension POIVC: AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        print(response.count)
        hideLoadHUD()
        if response.count == 0 {
            return
        }
    
        for poi in response.pois{
//            poi.name
            let province = poi.province == poi.city ? "" : poi.province
            let address = poi.district == poi.address ? "" : poi.address
            
            let poi = [
                poi.name ?? kNoPOIPH,
                "\(province.unwrappedText)\(poi.city.unwrappedText)\(poi.district.unwrappedText)\(address.unwrappedText)"
            ]
            pois.append(poi)
            if request is AMapPOIAroundSearchRequest{
                aroundSearchPOIs.append(poi)
            }
        }
        
        tableView.reloadData()
    }
}

extension POIVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pois.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPOICellID, for: indexPath) as! POICell
        
        let poi = pois[indexPath.row]
        cell.poi = poi
        
        return cell
    }
}
extension POIVC: UITableViewDelegate{
    
}
