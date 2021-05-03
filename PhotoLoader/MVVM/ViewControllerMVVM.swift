//
//  ViewControllerMVVM.swift
//  PhotoLoader
//
//  Created by eyal avisar on 29/04/2021.
//

import UIKit
import Firebase

class ViewControllerMVVM: UIViewController {
    
    //MARK:- IBOUTLETS AND PROPERTIES
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var containerCollection: UICollectionView!
    
    private var photoViewModel: PhotoViewModel!

    private var items:[MVPhoto]!
    private var selectedImages: [MVPhoto] = []

    
    //MARK:- View methods

    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        photoViewModel = PhotoViewModel()
        photoViewModel.bindPhotosViewModelToControler = { [self] in
            updateDataSource()
        }
    }
    
    //MARK:- IBAction methods

    @IBAction func upload() {
        
        var index = items.count - 1
        while items.count > 0 {
            selectedImages.append(items[index])
            uploadToFirebase(photo: items[index].image)
            items.removeLast()
            index -= 1
        }
        photosCollection.reloadData()
        containerCollection.reloadData()
    }

    //MARK:- Helper methods

    func updateDataSource() {

        
        DispatchQueue.main.async {
            self.items = self.photoViewModel.photos.photos
            self.photosCollection.delegate = self
            self.photosCollection.dataSource = self
            self.photosCollection.reloadData()
        }
        
    }
    
    func uploadToFirebase(photo: UIImage) {

        guard let url = saveImage(image: photo)else {
            print("Image has no url")
            return
        }

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child(url.absoluteString)

        photoRef.putFile(from: url, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("error:", error!.localizedDescription)
                return
            }

            print("Photo uploaded")
        }
    }
    
    func saveImage(image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.5) ?? image.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return directory.appendingPathComponent("fileName.png")
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

extension ViewControllerMVVM: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Collection view extension

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 100 {
            return selectedImages.count
        }
        else if collectionView.tag == 100 {return 0}

        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCell
            
            cell.selectedImageView.image = selectedImages[indexPath.row].image
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.photoImageView.image = items[indexPath.row].image

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        items[indexPath.row].isUploaded = true
        uploadToFirebase(photo: items[indexPath.row].image)
        selectedImages.append(items[indexPath.row])
        
        items.remove(at: indexPath.row)

        let selectedIndex = IndexPath(row: selectedImages.count - 1, section: 0)

        UIView.animate(withDuration: 0.4, delay: 0, options: []) {
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            cell.photoImageView.alpha = 0
        } completion: { [self] (_) in
            self.photosCollection.deleteItems(at: [indexPath])
            self.containerCollection.insertItems(at: [selectedIndex])
            
        }
        return false
    }
}
