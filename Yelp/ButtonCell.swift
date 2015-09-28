//
//  ButtonCell.swift
//  Yelp
//
//  Created by Emily M Yang on 9/25/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     //   button.layer.borderColor = UIColor.darkGrayColor().CGColor
    //    button.backgroundColor = UIColor.lightGrayColor()
        button.setImage(UIImage(named: "buttonoff.png"), forState:  UIControlState.Normal)
        button.setImage(UIImage(named: "buttonOn.png"), forState:  UIControlState.Selected)
        // Initialization code
    }
    

    
    var select: Bool! {
        didSet {
            if (select != nil) && select == true {
               // button.layer.borderColor = UIColor.darkGrayColor().CGColor
               // button.backgroundColor = UIColor.redColor()
                button.setImage(UIImage(named: "buttonOn.png"), forState:  UIControlState.Normal)
                 print("setting Button Images")

            } else {
              //  button.layer.borderColor = UIColor.darkGrayColor().CGColor
             //   button.backgroundColor = UIColor.lightGrayColor()
                button.setImage(UIImage(named: "buttonoff.png"), forState:  UIControlState.Normal)
                 print("setting Button Images")
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
