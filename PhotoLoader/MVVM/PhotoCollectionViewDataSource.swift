//
//  PhotoCollectionViewDataSource.swift
//  PhotoLoader
//
//  Created by eyal avisar on 29/04/2021.
//

import Foundation
import UIKit

class PhotoCollectionViewDataSource<CELL: UICollectionViewCell, T>: NSObject, UICollectionViewDataSource {
    
    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (CELL, T) -> () = {_,_ in }
        
        
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("items", items.count)
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let item = items[indexPath.row] as! MVPhoto
        
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCell
            
            cell.selectedImageView.image = selectedImages[indexPath.row].image
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.photoImageView.image = item.image

//        configureCell(cell as! CELL, item)
        return cell
    }
}
