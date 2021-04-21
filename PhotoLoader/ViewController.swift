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
    @IBOutlet weak var containerCollection: UICollectionView!
    
    @IBOutlet weak var libraryPhotosCollection: UICollectionView!
    
    //MARK:- properties
    
    var selectedImages = [UIImage]()
    var images = [UIImage]()

    
    //MARK:- Collection delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("images count", images.count)
        if collectionView.tag == 100 {
            return selectedImages.count
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCell
            
            cell.selectedImageView.image = selectedImages[indexPath.row]
                
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.photoImageView.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedImages.append(images[indexPath.row])
        containerCollection.reloadData()
    }
    

    //MARK:- View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryPhotosCollection.dataSource = self
        libraryPhotosCollection.delegate = self
        
        populatePhotos()

    }

    //MARK:- Helper methods
    func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                
                print("assets", assets)
                assets.enumerateObjects { (object, _, _) in
                    
                    var myImage = UIImage()
                    let manager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    option.isSynchronous = true
                    manager.requestImage(for: object, targetSize: CGSize(width: 100,height: 100), contentMode: .aspectFit, options: option) { (image, _) in
                        myImage = image!
                        self?.images.append(myImage)
                    }
                }
                
                
                DispatchQueue.main.async {
                    self?.libraryPhotosCollection.reloadData()
                }
            }
        }
    }
    
    @IBAction func upload() {
        selectedImages = images
        containerCollection.reloadData()
    }
    
}


