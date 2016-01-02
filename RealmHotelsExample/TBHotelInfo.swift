//
//  TBHotelInfo.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import RealmSwift

public class TBHotelInfo: Object {
    
    private static var counter:Int = 0
    public class func newBusinessId() -> String? {
        return "\(counter++)"
    }
    
    public dynamic var businessId: String?
    public dynamic var name: String?
    public dynamic var latitude: Double = 37.7859547
    public dynamic var longitude: Double = -122.4024658
    public dynamic var phoneNumber: String?
    
    override public static func primaryKey() -> String? {
        return "businessId"
    }
}
