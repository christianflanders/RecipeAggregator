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
    
    func getPreviewImageURLFromHTML(url: String) -> URL?{
        let myURL = URL(string: url)
        let searchFor = "meta property=\"og:image\" content="
        do {
            let myHTML = try String(contentsOf: myURL!, encoding: .ascii)
            let array = myHTML.components(separatedBy: "<")
            let filtered = array.filter {
                $0.contains(searchFor)
            }
            print(filtered)
            if filtered.count != 0 {
                let thingsToFilter = [searchFor, "\"", ">", " /", "\n"]
                var imageURL = filtered[0]
                for i in thingsToFilter {
                    imageURL = imageURL.replacingOccurrences(of: i, with: "")
                }
                print("The image url is \(imageURL)")
                if let urlForImage = URL(string: imageURL) {
                    return  urlForImage
                } else {
                    print("No image found or something went wrong")
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            print("Error")
            return nil
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
