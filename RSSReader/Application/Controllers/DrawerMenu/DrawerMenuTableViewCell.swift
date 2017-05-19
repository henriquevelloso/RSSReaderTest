//
//  DrawerMenuTableViewCell.swift
//  BraviTest
//
//  Created by Henrique Velloso on 19/05/17.
//
//

import UIKit

class DrawerMenuTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var url: UILabel!
    
    
    //MARK: - View Delegates
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
