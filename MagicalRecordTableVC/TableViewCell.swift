//
//  TableViewCell.swift
//  MagicalRecordTableVC
//
//  Created by IwasakIYuta on 2021/08/15.
//

import UIKit

class TableViewCell: UITableViewCell {
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(label)
        
        label.textAlignment = .left        
        label.clipsToBounds = true
        label.bounds.size = self.bounds.size
    }
   

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
