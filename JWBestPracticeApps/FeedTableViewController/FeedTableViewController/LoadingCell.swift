//
//  LoadingCell.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/27/22.
//

import UIKit

class LoadingCell: UITableViewCell {
    // Reuse ID
    static   let reuseIdentifer = "loadingCellReuseId"
    override var reuseIdentifier: String? { LoadingCell.reuseIdentifer }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
