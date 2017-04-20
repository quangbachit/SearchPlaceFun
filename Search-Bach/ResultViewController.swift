//
//  ResultViewController.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/7/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import UIKit
import Pulley

let appdelegate = UIApplication.shared.delegate as? AppDelegate

class ResultViewController: UIViewController {

    var arrayAddress = [StoreService]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineTop: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appdelegate?.MapVC.delegate = self

        updateUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "listResultCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listResultCell")
        
        let nothingNib = UINib(nibName: "NothingCell", bundle: nil)
        tableView.register(nothingNib, forCellReuseIdentifier: "NothingCell")
        
        tableView.reloadData()
        
    }
    
    func updateUI(){
        lineTop.layer.cornerRadius = 5
    }
}

extension ResultViewController: DataSelectDelegate {
    func dataLoad(data: [StoreService]) {
        arrayAddress = data
        tableView.reloadData()
    }
}


extension ResultViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayAddress.count == 0 {
            return 1
        } else {
            return arrayAddress.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayAddress.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listResultCell", for: indexPath) as! listResultCell
            
            cell.configureCell(data: arrayAddress[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = arrayAddress[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailCotroller
        detailVC.detail = cell
        present(detailVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.bounds.width/5
    }
    

}

extension ResultViewController: PulleyDrawerViewControllerDelegate {
    public func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    public func partialRevealDrawerHeight() -> CGFloat {
        return view.bounds.height/2
    }
    
    //chiều cao PulleyDrawer
    func collapsedDrawerHeight() -> CGFloat {
        return 30.0
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition == .open {
            tableView.isScrollEnabled = true
        }
    }
    
}



