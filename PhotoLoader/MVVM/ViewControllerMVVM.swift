//
//  ViewControllerMVVM.swift
//  PhotoLoader
//
//  Created by eyal avisar on 29/04/2021.
//

import UIKit

class ViewControllerMVVM: UIViewController {
    @IBOutlet weak var photosCollection: UICollectionView!
    
    private var photoViewModel: PhotoViewModel!
    private var dataSource: PhotoCollectionViewDataSource<UICollectionViewCell, MVPhoto>!
    
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
    
    func updateDataSource() {
        dataSource = PhotoCollectionViewDataSource(cellIdentifier: "MVPhotoCell", items: self.photoViewModel.photos.photos, configureCell: { cell, pvm in
        })
        
        DispatchQueue.main.async {
            print("In async")
            self.photosCollection.dataSource = self.dataSource
            self.photosCollection.reloadData()
        }
        
    }
}
