//
//  CustomLabel.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/11/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
    }
    
    
}
