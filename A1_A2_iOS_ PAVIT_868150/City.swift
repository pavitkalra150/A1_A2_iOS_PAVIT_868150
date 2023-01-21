//
//  City.swift
//  A1_A2_iOS_ PAVIT_868150
//
//  Created by PAVIT KALRA on 2023-01-20.
//

import Foundation
import MapKit

class City : NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
}
