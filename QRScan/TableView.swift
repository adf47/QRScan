//
//  TableView.swift
//  QRScan
//
//  Created by Antonino Febbraro on 9/22/16.
//  Copyright © 2016 Antonino Febbraro. All rights reserved.
//


/*
    THIS CODE DEALS WITH ADDING SCANNED ITEMS TO THE TABLE VIEW ON THE "SCANNED ITEMS" PAGE OF THE APP
 */

import Foundation
import UIKit

class TableView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var refresh:UIRefreshControl!
    let cellReuseIdentifier = "cell"
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("View appeared")
        self.tableView.reloadData()
        self.tableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("View Appeared")
       
        self.tableView.reloadData()
        self.tableView.isHidden = false
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to Refresh Page")
        refresh.addTarget(self, action: #selector(TableView.loadData), for: .valueChanged)
        self.tableView.addSubview(refresh)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 1000.0
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.main.async {
            self.loadData()
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ScannerViewController.Constants.TitleArray.count)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        
        cell.textLabel?.text = ScannerViewController.Constants.TitleArray[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //display content here
        let alertController2 = UIAlertController(
            title: ScannerViewController.Constants.TitleArray[indexPath.row],
            message: ScannerViewController.Constants.TitleArray[indexPath.row],
            preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(
        title: "Done", style: UIAlertActionStyle.default) {
            (action) -> Void in
        }
        
        alertController2.addAction(action)
        self.present(alertController2, animated: true, completion: nil)
    }
    
    
    
    func loadData(){
        self.tableView.reloadData()
        self.tableView.isHidden = false
    }
    
}
