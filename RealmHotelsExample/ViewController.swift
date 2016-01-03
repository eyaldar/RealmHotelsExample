//
//  ViewController.swift
//  RealmHotelsExample
//
//  Created by Eyal Darshan on 1/2/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import UIKit
import RealmSwift
import RealmMapView
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: RealmMapView!
    
    let ABFAnnotationViewReuseId = "ABFAnnotationViewReuseId"
    let InitialDataCount = 200
    let TickDataCount = 1200
    let locationManager = CLLocationManager()
    var myId:String?
    var count = 0
    var dataArr = [TBHotelInfo]()
    var annotation:MKPointAnnotation?
    var timer = NSTimer()
    let profileImage = UIImage(named: "1.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataBuilder = TBHotelCSVDataBuilder()
        dataArr = dataBuilder.getData("USA-HotelMotel")
        
        let config = Realm.Configuration.defaultConfiguration
        mapView.realmConfiguration = config
        mapView.fetchedResultsController.clusterTitleFormatString = "$OBJECTSCOUNT hotels in the area"
        mapView.delegate = self
        mapView.basePredicate = NSPredicate(format: "name CONTAINS 'me'")
        
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
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
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
            if safeObjects.count > 1 {
                if let firstObjectName = safeObjects.first?.toObject(TBHotelInfo).name {
                    print("First Object: \(firstObjectName)")
                }
            } else {
                //NSBundle.mainBundle().loadNibNamed("SingleAnnotationCalloutView", owner: self, options: nil)
                //let hitPoint = view.convertPoint(CGPointZero, toView: mapView)
            }
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let fetchedAnnotation = annotation as? ABFAnnotation {
    
            var annotationView:ABFClusterAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(ABFAnnotationViewReuseId) as? ABFClusterAnnotationView
            if annotationView == nil {
                annotationView = ABFClusterAnnotationView(annotation: annotation, reuseIdentifier: ABFAnnotationViewReuseId)
                annotationView?.canShowCallout = true
            }
            
            annotationView?.count = UInt(fetchedAnnotation.safeObjects.count)
            annotationView?.annotation = fetchedAnnotation
            
            if annotationView?.count == 1 {
                let hotelInfo = fetchedAnnotation.safeObjects.first!.toObject(TBHotelInfo)
                annotationView?.tag = Int(hotelInfo.businessId!)!
            }
            
            return annotationView!
        } else if let fetchedAnnotation = annotation as? MKUserLocation {
            var annotationView:SVPulsingAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("MyLocation") as? SVPulsingAnnotationView
            
            if annotationView == nil {
                annotationView = SVPulsingAnnotationView(annotation: annotation, reuseIdentifier: "MyLocation")
                annotationView?.canShowCallout = true
                annotationView?.annotationColor = UIColor(red:0.2, green: 0.4, blue: 1, alpha: 1)
                annotationView?.image = profileImage
            }
            
            annotationView?.annotation = fetchedAnnotation
            
            return annotationView
        }
        
        return nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let coordinate = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        self.mapView.setRegion(region, animated: true)
        
        locationManager.delegate = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors:" + error.localizedDescription)
    }
    
    
}

