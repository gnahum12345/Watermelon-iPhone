//
//  HistoryCell.swift
//  Watermelon Scanner
//
//  Created by Gabriel Nahum on 12/31/17.
//  Copyright © 2017 Gabriel. All rights reserved.
//

import Foundation

import UIKit

class HistoryCell: UITableViewCell {
    // MARK: Properties
    
    
    @IBOutlet weak var algorithmRating: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var fruitPic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
