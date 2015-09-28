//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Emily M Yang on 9/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filter)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?

    var categories = [[String:String]]()

    
    var switchStates = [NSIndexPath:Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
         loadCategories()
   //    categories = yelpCategories();

        // Do any additional setup after loading the view.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadCategories() {
        let categoriesURL = NSURL(string: "https://s3-media2.fl.yelpcdn.com/assets/srv0/developer_pages/5e749b17ad6a/assets/json/categories.json")
        
        let request = NSURLRequest(URL: categoriesURL!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 0.0)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? NSArray
                    if let json = json {
                        for category in json! {
                            for parent in (category["parents"] as! NSArray) {
                                if !parent.isKindOfClass(NSNull) && (parent as! String) == "restaurants"{
                                    let categoryToAdd = ["name":(category["title"] as! String), "code":(category["alias"] as! String)]
                                    self.categories.append(categoryToAdd)
                                }
                            }
                        }
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            task.resume()
        }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Sections.count.rawValue
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return Sections(rawValue: section)?.getTitle()
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell
        headerCell.backgroundColor = UIColor.whiteColor()
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = Sections(rawValue: section)?.getTitle()
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = Sections(rawValue: section)?.getTitle()
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = Sections(rawValue: section)?.getTitle()
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = Sections(rawValue: section)?.getTitle()
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        switch Sections(rawValue: indexPath.section)! {
        case .offeringDeal:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath:indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.on  = switchStates[indexPath] ?? false
            return cell
            
        case .distance:
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ButtonCell
            cell.rowLabel.text = Distances(rawValue: indexPath.row)?.getDistanceTitle()
            cell.select  = switchStates[indexPath] ?? false

            return cell
            
        case .sortBy:
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ButtonCell
            cell.rowLabel.text = YelpSortMode(rawValue: indexPath.row)?.getTitle()
            cell.select  = switchStates[indexPath] ?? false
            return cell
            
        case .category:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath:indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.on  = switchStates[indexPath] ?? false
            return cell
            
        case .count:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath:indexPath) as! SwitchCell
            print(true, "Error getting table view cell for this index")
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .offeringDeal:
            return 1
        case .distance :
            return Distances.count.rawValue
        case .sortBy:
            return YelpSortMode.count.rawValue
        case .category:
            return categories.count
        case .count:
            print("invalid number of sections")
        }
        return 0
    }
    
    @IBAction func onFilterButtonPressed(sender: AnyObject) {
                //get the section that it's from
        let selectedIndexPath = tableView.indexPathForCell(sender.superview!!.superview as! UITableViewCell)
        print("filter Button Pressed")
        print(selectedIndexPath!.section)
        print(selectedIndexPath!.row)

        if switchStates[selectedIndexPath!] == nil{
            for(var i = 0; i<tableView.numberOfRowsInSection((selectedIndexPath?.section)!); i++){
                let tempIP = NSIndexPath(forRow: i, inSection: (selectedIndexPath?.section)!)
                switchStates[tempIP] = false
            }
        }

        //set that button to selected
        //go through all the other buttons in that section and mark them as not selected
        for (indexPath, _) in switchStates {
            if indexPath.section == selectedIndexPath?.section  {
                if indexPath.row == selectedIndexPath?.row {
                    print("index set to true")
                    switchStates[indexPath] = true
                }else{
                    print("index set to false")
                    switchStates[indexPath] = false
                }
            }
        }
        

        tableView.reloadData()
        
    }
    
    
    @IBAction func onSearch(sender: AnyObject) {
        
        
        var filters = Filter()
        var selectedCategories = [String]()
        filters.distance = Distances.Mile10.getDistanceInMeters()
        filters.sortBy = YelpSortMode.BestMatched

        for (indexPath, isSelected) in switchStates {
            //Get Categories
            if (indexPath.section == Sections.category.rawValue){
                if isSelected {
                    selectedCategories.append(categories[indexPath.row]["code"]!)
                    print(categories[indexPath.row]["code"])
                }
            }
            //get distance
            if (indexPath.section == Sections.distance.rawValue){
                if isSelected {
                    filters.distance = Distances(rawValue: indexPath.row)?.getDistanceInMeters()
                    print(filters.distance)
                }
            }
            //get sort by
            if (indexPath.section == Sections.sortBy.rawValue){
                if isSelected {
                    filters.sortBy = YelpSortMode(rawValue: indexPath.row)!
                    print(filters.sortBy?.getTitle())
                }
            }
            
        }
        //get deals
        filters.deal = switchStates[NSIndexPath(forRow: 0, inSection: Sections.offeringDeal.rawValue)] ?? false
        print(filters.deal)

        filters.categories = selectedCategories

   
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool){
        let indexPath = tableView.indexPathForCell(switchCell)!
        switchStates[indexPath] = value
        
    }
    

    //enum for section headers in filters view
    enum Sections : Int{
        
        case offeringDeal=0, distance, sortBy, category, count
        
        static let headerTitles = [
            offeringDeal: "",
            distance: "Distance",
            sortBy: "Sort By",
            category: "Category"
        ]
        
        func getTitle() -> String {
            if let title = Sections.headerTitles[self] {
                return title
            } else {
                return "Error: passed in a number that is not valid"
            }
        }
        
    }
    
    enum Distances : Int{
        
        case Mile05=0, Mile1, Mile5, Mile10, Mile20, count
        
        static let distanceTitles = [
            Mile05: "0.5 Miles",
            Mile1: "1 Mile",
            Mile5: "5 Miles",
            Mile10: "10 Miles",
            Mile20: "20 Miles"
        ]
        
        static let distanceInMeters = [
            Mile05: 805,
            Mile1: 1609,
            Mile5: 8047,
            Mile10: 16093,
            Mile20: 32187
        ]
        
        func getDistanceTitle() -> String {
            if let distanceTitle = Distances.distanceTitles[self] {
                return distanceTitle
            } else {
                return "Error: passed in a number that is not valid"
            }
        }
        
        func getDistanceInMeters() -> Int{
            if let distanceInMeters = Distances.distanceInMeters[self] {
                return distanceInMeters
            } else {
                return 16093
            }
        }
    }
    
}
