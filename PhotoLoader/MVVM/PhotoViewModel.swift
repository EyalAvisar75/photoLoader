//
//  PhotoModel.swift
//  PhotoLoader
//
//  Created by eyal avisar on 29/04/2021.
//

import Foundation
import Photos

class PhotoViewModel: NSObject {
    private var apiService:	APIService!
    private(set) var photos: MVPhotos! {
        didSet {
            bindPhotosViewModelToControler()
        }
    }
    
    var bindPhotosViewModelToControler: (()->()) = {}
    
    override init() {
        super.init()
        apiService = APIService()
        getPhotos()
    }
    
    func getPhotos() {
        apiService.apiToGetPhotos() { photos in
            self.photos = photos
        }
    }
    
}
