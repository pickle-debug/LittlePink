//
//  POIVC-keywordsSearch.swift
//  LittlePink
//
//  Created by mac on 2021/12/19.
//

extension POIVC: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { dismiss(animated: true) }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            //重置(reset)
            pois = aroundSearchPOIs//恢复为之前的周边搜索数据
            setAroundSearchFooter()//恢复为周边搜索的上拉加载功能(防止之前是从关键字搜索过来的)
            
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.isBlank else { return }
        keywords = searchText
        
        //重置(reset)
        pois.removeAll()//恢复为检索前的空数据状态
        currentKeywordsPage = 1//恢复内存中的当前页数(防止还停留在之前一次的关键字检索中,比如之前加载3页,这次检索开始时就为3)
        
        setKeywordsSearchFooter()
        
        showLoadHUD()
        makeKeywordsSearch(keywords)
    }
}

//MARK: - 所有搜索POI的回调-AMapSearchDelegate
extension POIVC: AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        var poiCount = response.count
        print(poiCount)
        hideLoadHUD()

        if poiCount > kPOIsOffset {
            pageCount = poiCount / kPOIsOffset + 1
        }else{
            footer.endRefreshingWithNoMoreData()
        }

        if poiCount == 0 {
            return
        }
    
        for poi in response.pois{

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

//MARK: - 一般函数
extension POIVC{
    private func makeKeywordsSearch(_ keywords: String, _ page: Int = 1){
        keywordsSearchRequest.keywords = keywords
        keywordsSearchRequest.page = page
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }
    private func setKeywordsSearchFooter(){
        footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(keywordsSearchPullToRefresh))
    }
}
//MARK: - 监听
extension POIVC{
    @objc private func keywordsSearchPullToRefresh(){
        currentKeywordsPage += 1
        makeKeywordsSearch(keywords, currentKeywordsPage)
        endRefreshing(currentKeywordsPage)
    }
}
