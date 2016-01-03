//
//  CustomClusterAnnotationView.swift
//  RealmHotelsExample
//
//  Created by Eyal Darshan on 1/2/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import ABFRealmMapView

class CustomClusterAnnotationView: ABFClusterAnnotationView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        
    }
}
