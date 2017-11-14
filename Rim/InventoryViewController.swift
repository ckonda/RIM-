//
//  InventoryViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/27/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var arrayofIcons = [UIImage]()
    var arrayofIDs = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrayofIcons = [#imageLiteral(resourceName: "Beak"),#imageLiteral(resourceName: "Beak"),#imageLiteral(resourceName: "Beak"),#imageLiteral(resourceName: "Beak"),#imageLiteral(resourceName: "Beak"),#imageLiteral(resourceName: "Beak")]
        let arrayofIDs = ["G","H","I","J","K","L"]

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayofIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = arrayofIcons[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let name = arrayofIDs[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: name)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    

    
  

}
