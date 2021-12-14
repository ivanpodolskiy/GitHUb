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
    
 
    var imags = [ UIImage(named:
        "avatar0"),
                  UIImage(named:  "avatar2"),
                  UIImage(named:  "avatar1"),
                  UIImage(named:
                      "avatar0"),
                                UIImage(named:  "avatar2"),
                                UIImage(named:  "avatar1"),
                  UIImage(named:
                      "avatar0"),
                                UIImage(named:  "avatar2"),
                                UIImage(named:  "avatar1"),
                  UIImage(named:
                      "avatar0"),
                                UIImage(named:  "avatar2"),
                                UIImage(named:  "avatar1"),
                  UIImage(named:
                      "avatar0"),
                                UIImage(named:  "avatar2"),
                                UIImage(named:  "avatar1")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
     
        blurV2()
    }
    
    
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imags.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let num = [1,2,3]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
     
        
//        cell.imageView?.image = UIImage(named: "avatar" + String(indexPath.row))

        let inputImage = imags[indexPath.row]
        cell.imageView?.image = inputImage
        
//        blur(image: inputImage!, andApplyToView: cell.imageView!)

        return cell
    }
    
    func blur(image: UIImage, andApplyToView view: UIImageView) {
        
        DispatchQueue.global(qos: .userInteractive).async {
//            let image = UIImage(named: "avatar0")!
            let inputCIImage = CIImage(image: image) //image переводится в ciimage
            
            let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey : inputCIImage])!
            let outputImage = blurFilter.outputImage!
            
            let context = CIContext()
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent) //переводим в cgimage
            
            let blurImage = UIImage(cgImage: cgiImage!)
            
            DispatchQueue.main.async {
                view.image = blurImage
            }
     
        }
        
        
       
        
        
    }
    
    func blurV2() {
        var bluredImages = imags
        var dispatchGroup = DispatchGroup()
        
        for element in bluredImages.enumerated() {
            DispatchQueue.global().async(group: dispatchGroup) {
                let inputImage = element.element
                let inputCIImage = CIImage(image: inputImage!)
                
                let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey : inputCIImage])!
                let outputImage = blurFilter.outputImage!
                let context = CIContext()
                let cgiImage = context.createCGImage(outputImage, from: outputImage.extent)
                
                bluredImages[element.offset] = UIImage(cgImage: cgiImage!)
            }
            
         
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.imags = bluredImages
            self.tableView.reloadData()
        }
    }
    
}

