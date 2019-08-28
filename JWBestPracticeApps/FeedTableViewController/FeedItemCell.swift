//
//  FeedItemCell.swift
//  FeedTableViewController
//
//  Created by David Almaguer on 8/14/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

import UIKit

let FeedItemCellDefaultHeight: CGFloat = 300
let FeedItemCellIdentifier: String = "FeedItemCell"

class FeedItemCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    override var reuseIdentifier: String? {
        return FeedItemCellIdentifier
    }
    
}
