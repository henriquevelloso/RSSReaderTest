//
//  FeedItemTableViewCell.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {
    
    
    //MARK: - Outlets

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var imageDefaut: UIImageView!
    
    
    //MARK: - Delegates
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
