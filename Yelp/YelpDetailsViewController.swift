//
//  YelpDetailsViewController.swift
//  Yelp
//
//  Created by Emily M Yang on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class YelpDetailsViewController: UIViewController {


    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var ratingsImage: UIImageView!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = business.name
        categoriesLabel.text = business.categories
        backgroundImage.setImageWithURL(business.imageURL)
        addressLabel.text = business.address
        reviewsLabel.text = "\(business.reviewCount!) Reviews"
        ratingsImage.setImageWithURL(business.ratingImageURL)
        distanceLabel.text = business.distance
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
