//
//  WindowMaker.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/8/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class WindowMaker: UIView, GMSMapViewDelegate {

    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configWindowMaker(data: StoreService){
        
        nameLb.text = data.name
        addressLb.text = data.address
        imgBg.image = UIImage(named: data.type)

    }
    

}
