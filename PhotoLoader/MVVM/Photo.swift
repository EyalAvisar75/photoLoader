//
//  Photo.swift
//  PhotoLoader
//
//  Created by eyal avisar on 29/04/2021.
//

import Foundation
import UIKit
import Photos


struct MVPhoto {
    var image = UIImage()
    var url = URL(string: "")
    var isUploaded = false
}

struct MVPhotos {
    var photos: [MVPhoto]
}
