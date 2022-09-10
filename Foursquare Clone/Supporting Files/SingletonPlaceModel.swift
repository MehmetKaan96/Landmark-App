//
//  SingletonPlaceModel.swift
//  Foursquare Clone
//
//  Created by mehmet on 8.09.2022.
//

import Foundation
import UIKit


class Places {
    
    static let sharedInstance = Places()
    
    var placeName = ""
    var placeType = ""
    var placeDesc = ""
    var placeImg = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    private init() { }
}
