//
//  ViewController.swift
//  PhotoLoader
//
//  Created by eyal avisar on 21/04/2021.
//

import UIKit
import Photos
import FirebaseStorage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK:- IBOutlets
    @IBOutlet weak var containerCollection: UICollectionView!
    
    @IBOutlet weak var libraryPhotosCollection: UICollectionView!
    
    //MARK:- View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryPhotosCollection.dataSource = self
        libraryPhotosCollection.delegate = self
        populatePhotos(){
            DispatchQueue.main.async {
                assetsForURL()
                self.libraryPhotosCollection.reloadData()
            }
        }
    }
    

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
            
            cell.selectedImageView.image = selectedImages[indexPath.row].image
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.photoImageView.image = images[indexPath.row].image
//        print(images[indexPath.row])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        uploadToFirebase(photo: images[indexPath.row])
        moveImage(index: indexPath.row)

        let selectedIndex = IndexPath(row: selectedImages.count - 1, section: 0)

        UIView.animate(withDuration: 0.4, delay: 0, options: []) {
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            cell.photoImageView.alpha = 0
        } completion: { [self] (_) in
            self.libraryPhotosCollection.deleteItems(at: [indexPath])
            self.containerCollection.insertItems(at: [selectedIndex])
            
        }
        return false
    }
    
    //MARK:- IBActions
    @IBAction func upload() {
        
        while images.count > 0 {
            moveImage()
            libraryPhotosCollection.deleteItems(at: [IndexPath(row: 0, section: 0)])
            let indexPath = IndexPath(row: selectedImages.count - 1, section: 0)
            
            containerCollection.insertItems(at: [indexPath])
            uploadToFirebase(photo: selectedImages.last!)
        }

        libraryPhotosCollection.reloadData()
    }
    
    //MARK:- Helper methods

    
    func uploadToFirebase(photo: MyPhotos) {
//        print("uploadToFirebase url:", photo.urlString)
//        if photo.urlString == "" {
//            print("Empty string")
//            return
//        }
//        if photo.url == "" {
//            print("Empty url")
//            return
//        }
        let storage = Storage.storage()
//        let data = Data()
        let storageRef = storage.reference()
        let photoRef = storageRef.child(photo.url.absoluteURL.description)

        let m = UIImage(imageLiteralResourceName: String(photo.url.description.dropFirst("file:///file:".count)))
        if m != nil {
            print("succeded")
        }
        
        else {
            print("failed")
        }
        photoRef.putFile(from: URL(fileURLWithPath: photo.url.absoluteString), metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("error:", error!.localizedDescription)
                return
            }
            
            print("Photo uploaded")
        }
    }
    
//    func downloadFromFireBase(photo: MyPhotos) {
//        let storage = Storage.storage()
//        let storageRef = storage.reference(withPath: photo.urlString)
//
//        storageRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                if let data = data {
//                    var myPhoto = MyPhotos()
//                    if let image = UIImage(data: data) {
//                        myPhoto.image = image
//                    }
//                    else {
//                        print("download failed")
//                        return}
//                    myPhoto.urlString = photo.urlString
//                    selectedImages.append(myPhoto)
//                    self.containerCollection.insertItems(at: [IndexPath(row: selectedImages.count - 1, section: 0)])
//                }
//            }
//        }
//    }
}


