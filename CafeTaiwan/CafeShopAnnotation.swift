//
//  CafeShopAnnotation.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/6/23.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import MapKit

class CafeShopAnnotation: MKPointAnnotation {
    override var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
        set {
            self.coordinate = newValue
        }
    }
    
    var id = ""
    var city = ""
    var name = ""
    var wifi = Double()
    var seat = Double()
    var quiet = Double()
    var tasty = Double()
    var cheap = Double()
    var music = Double()
    var address = ""
    var latitude = Double()
    var longitude = Double()
    var url = ""
    var limited_time = ""
    var socket = ""
    var standing_desk = ""
    var mrt = ""
    var open_time = ""
    
}
