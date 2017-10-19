//
//  StoredImageClass.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

class StoredImages {
    var images = [String:UIImage]()
    
     func downloadImageFromURL(_ url:URL) -> UIImage {
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                print("Something went wrong downloading the image")
                return #imageLiteral(resourceName: "errorstop")
            }
            
        } catch {
            print("Something went wrong downloading the image")
            return #imageLiteral(resourceName: "errorstop")
            
        }
    }
//    func downloadAllImagesFromArray(_ inputArray: [RecipeFromURL]) {
//        for i in inputArray {
//            guard let imagePreviewURL = i.previewImageURL else {
//                //dosomething here
//                return
//            }
//            if let url = URL(string: imagePreviewURL) {
//                DispatchQueue.main.async {
//                    let image = self.downloadImageFromURL(url)
//                    self.images[i.url!] = image
//                }
//                
//            }
//        }
//    }
//    
    

    
}
