//
//  TBCoordinateQuadTreeBuilder.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

class TBHotelCSVDataBuilder {
    
    func getData(dataFileName:String) -> [TBHotelInfo] {
        let data = getFileContent(dataFileName)
        let lines = data.componentsSeparatedByString("\n")
        
        var dataArray = [TBHotelInfo]()
        
        for line in lines {
            if line != "" {
                dataArray.append(dataFromLine(line))
            }
        }
        
        return dataArray
    }
    
    private func dataFromLine(line: NSString) -> TBHotelInfo {
        let components = line.componentsSeparatedByString(",")
        
        let latitude = Double(components[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!
        let longitude = Double(components[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!
        
        let hotelName = components[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let hotelPhoneNumber = components.last!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let hotelData = TBHotelInfo()
        hotelData.businessId = TBHotelInfo.newBusinessId()
        hotelData.latitude = latitude
        hotelData.longitude = longitude
        hotelData.name = hotelName
        hotelData.phoneNumber = hotelPhoneNumber
        
        return hotelData
    }
    
    private func getFileContent(fileName:String) -> String {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource(fileName, ofType: "csv")!
        var data = ""
        
        do {
            data = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch {}
        
        return data
    }
}