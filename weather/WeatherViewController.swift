//
//  WeatherViewController.swift - The main view. We handle man actions and view segues here.
//
//
//  Created by Ario K on 2016-02-18.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var currImage: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet var forecastViews: [ForecastView]!
    
    
    var loadXML: XMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadXML = XMLParser.xml
        //Load up all the UI elements here
        self.locationButton.setTitle(self.loadXML.currWeather[0], forState: .Normal)
        self.iconLabel.text = self.loadXML.currWeather[1]
        self.temperatureLabel.text = self.loadXML.currWeather[2]
        currImage.image = UIImage(named: self.loadXML.currWeather[3])
        for var i = 0; i < forecastViews.count; i++ {
            let forecast_day = self.loadXML.forecastInfo[i]
            if forecast_day != nil {
                let index3 = forecast_day?.day.startIndex.advancedBy(3)
                let day_substring = forecast_day?.day.substringToIndex(index3!)
                let temp_label = [forecast_day?.temp, "\u{00B0}"].flatMap{$0}.joinWithSeparator("")
                forecastViews[i].dayLabel.text = day_substring
                forecastViews[i].tempLabel.text = "\(temp_label)C"
                forecastViews[i].image = UIImage(named: (forecast_day?.image)!)
            }
        }
    }
    // ForecastView is a UIView loaded from the Nib so we need to implement touchesBegan inorder to detect taps.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.locationInView(forecastViews[0])
            if currentPoint.x < 56 && currentPoint.x > 0 && currentPoint.y > 10 && currentPoint.y < 100 {
                self.loadXML.defineForecastSummary(self.loadXML.forecastInfo[0]!.day)
                self.loadXML.setDetails(self.loadXML.getForecastSummary())
                self.performSegueWithIdentifier("details", sender: nil)
            } else if currentPoint.x < 112 && currentPoint.x > 56 && currentPoint.y > 10 && currentPoint.y < 100 {
                self.loadXML.defineForecastSummary(self.loadXML.forecastInfo[1]!.day)
                self.loadXML.setDetails(self.loadXML.getForecastSummary())
                self.performSegueWithIdentifier("details", sender: nil)
            } else if currentPoint.x < 168 && currentPoint.x > 112 && currentPoint.y > 10 && currentPoint.y < 100 {
                self.loadXML.defineForecastSummary(self.loadXML.forecastInfo[2]!.day)
                self.loadXML.setDetails(self.loadXML.getForecastSummary())
                self.performSegueWithIdentifier("details", sender: nil)
            } else if currentPoint.x < 224 && currentPoint.x > 168 && currentPoint.y > 10 && currentPoint.y < 100 {
                self.loadXML.defineForecastSummary(self.loadXML.forecastInfo[3]!.day)
                self.loadXML.setDetails(self.loadXML.getForecastSummary())
                self.performSegueWithIdentifier("details", sender: nil)
            } else if currentPoint.x < 280 && currentPoint.x > 224 && currentPoint.y > 10 && currentPoint.y < 100 {
                self.loadXML.defineForecastSummary(self.loadXML.forecastInfo[4]!.day)
                self.loadXML.setDetails(self.loadXML.getForecastSummary())
                self.performSegueWithIdentifier("details", sender: nil)
            } else if currentPoint.x < 336 && currentPoint.x > 280 && currentPoint.y > 10 && currentPoint.y < 100 {
                self.loadXML.defineForecastSummary(self.loadXML.forecastInfo[5]!.day)
                self.loadXML.setDetails(self.loadXML.getForecastSummary())
                self.performSegueWithIdentifier("details", sender: nil)
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    @IBAction func onInfoButtonPressed(sender: AnyObject) {
        self.loadXML.setDetails(self.loadXML.getCurrentSummary())
        self.performSegueWithIdentifier("details", sender: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("repick", sender: nil)
    }
    
}
