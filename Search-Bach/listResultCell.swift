//
//  listResultCell.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/7/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import UIKit

class listResultCell: UITableViewCell {

    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var octimeLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(data: StoreService) {
        nameLb.text = data.name
        octimeLb.text = data.octime
        addressLb.text = data.address
        imageBg.image = UIImage(named: data.type)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
