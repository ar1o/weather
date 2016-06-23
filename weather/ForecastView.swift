//
//  ForecastView.swift - This is a generic XIB swift file for the multiple forecast views
//  We will be keeping a collection of this view in the WeatherViewController for display.
//  All this does is load the required elements from the .XIB file.
// This file invokes the @IBDesignable interface
//
//  Created by Ario K on 2016-02-19.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

@IBDesignable class ForecastView: UIView {
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBInspectable var image: UIImage? {
        get {
            return forecastImage.image
        } set(image) {
            forecastImage.image = image
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        view = loadViewFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = loadViewFromNib()
    }

    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view);
        return view
    }

    private func nibName() -> String {
        return String(self.dynamicType)
    }

}
