//
//  Model.swift
//  PhotoLoader
//
//  Created by eyal avisar on 27/04/2021.
//

import Foundation
import UIKit
import Photos


struct MyPhotos {
    var image = UIImage()
    var url = URL(fileURLWithPath: "")
}

var images: [MyPhotos] = []
var selectedImages: [MyPhotos] = []

func moveImage(index: Int = 0) {
    selectedImages.append(images[index])
    images.remove(at: index)
}

func populatePhotos(completion: @escaping ()->()){
    PHPhotoLibrary.requestAuthorization {
        status in
        
        if status == .authorized {
            let assets = PHAsset.fetchAssets(with: .image, options: nil)
            
            assets.enumerateObjects { (object, _, _) in
                getPhotoImage(object: object)
//                getPhotoURL(object: object)
            }
            completion()
        }
    }
}

func assetsForURL() {
    let assets = PHAsset.fetchAssets(with: .image, options: nil)
    
    var assetCounter = 0
    assets.enumerateObjects { (object, _, _) in
        getPhotoURL(object: object, index: assetCounter)
        assetCounter += 1
    }
}

func getPhotoURL(object: PHAsset, index: Int) {
    object.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (editingInput, info) in
        if let input = editingInput, let imageURL = input.fullSizeImageURL {
            images[index].url = imageURL
        }
    }
}

func getPhotoImage(object: PHAsset) {
    var myPhoto = MyPhotos()
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    
    option.isSynchronous = true
    
    manager.requestImage(for: object, targetSize: CGSize(width: 100,height: 100), contentMode: .aspectFit, options: option) { (image, info) in
        
        myPhoto.image = image!
        images.append(myPhoto)
//        print("images", images)
    }
}
