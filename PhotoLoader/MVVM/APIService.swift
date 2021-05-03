//
//  APIService.swift
//  PhotoLoader
//
//  Created by eyal avisar on 29/04/2021.
//

import Foundation
import Photos

class APIService: NSObject {
    
    func apiToGetPhotos(completion: @escaping (MVPhotos)->()) {
        
        var photos = MVPhotos(photos: [])
        
        PHPhotoLibrary.requestAuthorization {
            status in
            
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                
                
                assets.enumerateObjects { [self] (object, _, x) in
                    
                    photos.photos.append(getPhotoImage(object: object))
                }
                completion(photos)
            }
        }
    }
    
    func getPhotoImage(object: PHAsset)-> MVPhoto {
        
        var myPhoto = MVPhoto()
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        option.isSynchronous = true
        
        manager.requestImage(for: object, targetSize: CGSize(width: 100,height: 100), contentMode: .aspectFit, options: option) { (image, info) in
            myPhoto.image = image!
        }
        return myPhoto
    }
}
