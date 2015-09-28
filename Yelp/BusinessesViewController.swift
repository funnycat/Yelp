//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {

    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    var searchBar : UISearchBar!
    
    

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
       
        
        navigationItem.titleView = searchBar

        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            
                self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        

        
//        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            self.tableView.reloadData()
//            
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil{
            return filteredBusinesses!.count
        }else{
            return 0
        }
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = self.filteredBusinesses[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  
        if segue.identifier == "filterView" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            
            filtersViewController.delegate = self
        }
        else {
            let yelpDetailsViewController = segue.destinationViewController as! YelpDetailsViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            let business = filteredBusinesses![indexPath!.row]
            yelpDetailsViewController.business = business
            view.endEditing(true)
        }
        
        

    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filter) {
        
        let categories = filters.categories as [String]
        let deal = filters.deal as Bool!
        let distance = filters.distance as Int!
        let sortBy = filters.sortBy as YelpSortMode!
        
        Business.searchWithTerm("Restaurants", sort: sortBy, categories: categories, deals:deal, distance:distance){
            (businesses:[Business]!, error:NSError!)-> Void in

                self.businesses = businesses
                self.filteredBusinesses = businesses
                self.tableView.reloadData()
            }
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBusinesses = searchText.isEmpty ? businesses : businesses!.filter({(business: Business) -> Bool in
            return business.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
    }
    

    @IBAction func onTap(sender: AnyObject) {
        print("HELLO")
        searchBar.resignFirstResponder()
        //view.endEditing(true)
    }

    /*.
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
