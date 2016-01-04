//
//  MapPinCalloutView.swift
//  CalloutViewTest
//
//  Created by Ran Ovadia on 1/4/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    @IBAction func buttonPressed(sender: AnyObject) {
        print("OOOO")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = NSBundle.mainBundle().loadNibNamed("CustomCalloutView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        styleButton(button)
        styleButton(button2)
        
        addSubview(view)
    }
    
    func styleButton(button:UIButton) {
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = button.frame.width / 2
        button.layer.shadowOpacity = 0.5
    }
    
    override func hitTest( point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let viewPoint = superview?.convertPoint(point, toView: self) ?? point
        
        _ = pointInside(viewPoint, withEvent: event)
        
        let view = super.hitTest(viewPoint, withEvent: event)
        
        return view
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return CGRectContainsPoint(bounds, point)
    }
}
