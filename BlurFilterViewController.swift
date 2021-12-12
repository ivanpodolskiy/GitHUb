//
//  BlurFilterViewController.swift
//  GitHUb
//
//  Created by user on 11.12.2021.
//

import Foundation
import UIKit
import CoreGraphics
class BlurFilterViewController: UITableViewController {
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        3
//    }
    

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let num = [1,2,3]
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "avatar" + String(indexPath.row))


        return cell
    }
    
}
