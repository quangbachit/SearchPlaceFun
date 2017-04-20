//
//  DetailCotroller.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/7/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import UIKit

class DetailCotroller: UIViewController {

    var detail: StoreService!
    
    //UICode
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var octimeLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var rateLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    func updateUI(){
        typeImage.image = UIImage(named: detail.type)
        nameLb.text = detail.name
        octimeLb.text = detail.octime
        addressLb.text = detail.address
        rateLb.text = "\(detail.rate)🎖"
        
    }
    
    
    @IBAction func dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
