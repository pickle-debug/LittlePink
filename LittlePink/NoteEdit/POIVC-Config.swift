//
//  POIVC-Config.swift
//  LittlePink
//
//  Created by mac on 2021/12/17.
//

import Foundation

extension POIVC{
    func config(){
        
        //定位
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.locationTimeout = 5

        locationManager.reGeocodeTimeout = 5
    }
}
