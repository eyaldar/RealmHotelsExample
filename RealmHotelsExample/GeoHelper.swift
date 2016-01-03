//
//  GeoHelper.swift
//  RealmHotelsExample
//
//  Created by Eyal Darshan on 1/2/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import MapKit
import CoreLocation

class GeoHelper {
    func directionBetweenPoints(pt1:CLLocationCoordinate2D, pt2:CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = pt1.latitude
        let long1 = pt1.longitude
    
        let lat2 = pt2.latitude
        let long2 = pt2.longitude
        
        let dLong = long2 - long1
        
        let y = sin(dLong) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * sin(lat2) * cos(dLong)
        
        let radiansBearing = atan2(y, x)
        
        return CLLocationDirection(radiansBearing * 180/M_PI)
    }
    
    func distanceBetweenPoints(pt1:CLLocationCoordinate2D, pt2:CLLocationCoordinate2D) -> CLLocationDistance {
        let point1 = MKMapPointForCoordinate(pt1)
        let point2 = MKMapPointForCoordinate(pt2)
        
        return MKMetersBetweenMapPoints(point1, point2)
    }
}