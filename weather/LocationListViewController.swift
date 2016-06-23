//
//  LocationListViewController.swift - List of locations that are available from the provided feed.csv file.
//  We parse the data in the .CSV file and present it in a UITableView here with delegates
//
//  Created by Ario K on 2016-02-16.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

struct cityInfo {
    var province: String
    var city: String
    var link: String
}

class LocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var loadXML: XMLParser!
    var weather = [Int:cityInfo]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadXML = XMLParser.xml
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        readCSV()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        let location = weather[indexPath.row]
        cell.textLabel?.text = location?.city
        cell.detailTextLabel?.text = location?.province
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(weather[indexPath.row])
        self.loadXML.configureParsing((self.weather[indexPath.row]?.link)!,city: (self.weather[indexPath.row]?.city)!, province: (self.weather[indexPath.row]?.province)! )
        self.performSegueWithIdentifier("main", sender: nil)
    }
    
    // Read the feed.csv here
    func readCSV() {
        let path = NSBundle.mainBundle().pathForResource("feeds.csv", ofType: "")
        do {
            if let data: NSString = try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) {
                let weatherData = data.componentsSeparatedByString("\r\n")
                var index = 0
                for city in weatherData {
                    let cityData = city.componentsSeparatedByString(",")
                    let trimCityString = cityData[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    let trimProvinceString = cityData[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                       weather[index++] = cityInfo(province: trimProvinceString, city: trimCityString, link: cityData[0])
                }
            }
        } catch {
            print("Error")
        }
    }


}
