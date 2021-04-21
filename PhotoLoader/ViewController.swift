//
//  ViewController.swift
//  PhotoLoader
//
//  Created by eyal avisar on 21/04/2021.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK:- IBOutlets
//    @IBOutlet weak var containerCollection: UICollectionView!
    
    @IBOutlet weak var libraryPhotosCollection: UICollectionView!
    
    //MARK:- properties
    private var images = [PHAsset]()
    private var selectedImages = [PHAsset]()

    
    //MARK:- Collection delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 {
            return selectedImages.count
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCell
            
            let asset = images[indexPath.row]
            let manager = PHImageManager.default()
            
            manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { (image, _) in

                DispatchQueue.main.async {
                    cell.selectedImageView.image = image
                }
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { (image, _) in

            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedImages.append(images[indexPath.row])
//        containerCollection.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        libraryPhotosCollection.dataSource = self
        libraryPhotosCollection.delegate = self
        
        populatePhotos()

    }

    func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                
                assets.enumerateObjects { (object, _, _) in
                    self?.images.append(object)
                }
                
//                self?.images.reverse()
                
                DispatchQueue.main.async {
                    self?.libraryPhotosCollection.reloadData()
//                    self?.containerCollection.reloadData()
                }
            }
        }
    }
    
}


