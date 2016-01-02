//
//  ViewController.swift
//  RealmHotelsExample
//
//  Created by Ran Ovadia on 1/2/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import UIKit
import RealmSwift
import RealmMapView

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: RealmMapView!
    
    let InitialDataCount = 4000
    let TickDataCount = 1200
    
    var count = 0
    var dataArr = [TBHotelInfo]()
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataBuilder = TBHotelCSVDataBuilder()
        dataArr = dataBuilder.getData("USA-HotelMotel")
        
        let config = Realm.Configuration.defaultConfiguration
        mapView.realmConfiguration = config
        mapView.fetchedResultsController.clusterTitleFormatString = "$OBJECTSCOUNT hotels in the area"
        mapView.delegate = self
        mapView.basePredicate = NSPredicate(format: "name CONTAINS 'Pr'")
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
        try! realm.write({ () -> Void in
            for i in 0..<InitialDataCount {
                realm.add(dataArr[i])
                count++
            }
        })
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("addNewItems"), userInfo: nil, repeats: true)
    }
    
    func addNewItems() {
        if count < dataArr.count {
            let realm = try! Realm()
            let end = count + TickDataCount
            try! realm.write({ () -> Void in
                for var i=count; i < end && i < dataArr.count ; i++ {
                    realm.add(dataArr[i])
                    count++
                }
                
                print("Current count: \(count)")
            })
            self.mapView.refreshMapView()
        } else {
            timer.invalidate()
        }
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let safeObjects = ABFClusterAnnotationView.safeObjectsForClusterAnnotationView(view) {
            if let firstObjectName = safeObjects.first?.toObject(TBHotelInfo).name {
                print("First Object: \(firstObjectName)")
            }
        }
    }


}

