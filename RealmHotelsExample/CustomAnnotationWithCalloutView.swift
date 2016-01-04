//
//  MapPin.swift
//  CalloutViewTest
//
//  Created by Ran Ovadia on 1/4/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import MapKit

class CustomAnnotationWithCalloutView: SVPulsingAnnotationView {
    class var reuseIdentifier:String {
        return "customAnnotationWithCallout"
    }
    
    private var calloutView:CustomCalloutView?
    private var hitOutside:Bool = true
    
    var preventDeselection:Bool {
        return !hitOutside
    }
    
    
    convenience init(annotation:MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: CustomAnnotationWithCalloutView.reuseIdentifier)
        
        canShowCallout = false;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let calloutViewAdded = calloutView?.superview != nil
        
        if (selected || !selected && hitOutside) {
            super.setSelected(selected, animated: animated)
        }
        
        self.superview?.bringSubviewToFront(self)
        
        if (calloutView == nil) {
            calloutView = CustomCalloutView(frame: CGRect(x: 15, y: -51, width: 88, height: 88))
        }
        
        if (self.selected && !calloutViewAdded) {
            addSubview(calloutView!)
        }
        
        if (!self.selected) {
            calloutView?.removeFromSuperview()
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, withEvent: event)
        
        if let callout = calloutView {
            if (hitView == nil && self.selected) {
                hitView = callout.hitTest(point, withEvent: event)
            }
        }
        
        hitOutside = hitView == nil
        
        return hitView;
    }
}