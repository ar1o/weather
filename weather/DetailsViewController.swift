//
//  DetailsViewController.swift - The details view controller is a UITableView
//
//
//  Created by Ario K on 2016-02-22.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var loadXML: XMLParser!
    var tableCount: Int!
    var tableArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Reference to the main model
        self.loadXML = XMLParser.xml
        // Set the required feilds to popular the table
         tableCount = self.loadXML.getDetailsInfo().count
         tableArray = self.loadXML.getDetailsInfo()
        // Set tableview delegats and datasource
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
        let str = tableArray![indexPath.row].stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        cell.textLabel?.text = str
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1) {
            return 200;
        }
        return 75
    }
    @IBAction func onCloseButtonPressed(sender: AnyObject) {
         self.performSegueWithIdentifier("close_details", sender: nil)
    }

}
