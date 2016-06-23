//
//  LocationViewController.swift
//  weather
//
//  Created by Ario K on 2016-02-18.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var loadXML: XMLParser!
    
    let filters = [
        "Red",
        "Blue",
        "Green",
        "Yellow",
    ]
    
    @IBAction func onAddButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("addButtonSegue", sender: nil)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadXML = XMLParser.xml
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loadXML.myLocations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("myLocationCell", forIndexPath: indexPath)
            let myLocation = self.loadXML.myLocations[indexPath.row]
        
            cell.textLabel?.text = myLocation?.city
            cell.detailTextLabel?.text = myLocation?.province
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(filters[indexPath.row])
        self.loadXML.getData((self.loadXML.myLocations[indexPath.row]?.link)!,city: (self.loadXML.myLocations[indexPath.row]?.city)!, province: (self.loadXML.myLocations[indexPath.row]?.province)!)
        self.performSegueWithIdentifier("myLocationCellSegue", sender: nil)

    }
    
}
