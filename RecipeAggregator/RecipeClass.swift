//
//  RecipeClass.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/11/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

struct Recipe{
    
    var name: String?
    var url : String
    var imageURL: URL?
    var image: UIImage?
    var meal: Meal
    
    
    init (url: String, meal: Meal){
        self.url = url
        self.meal = meal
        self.name = getPreviewNameFromHTML(url: url)
        self.imageURL = getPreviewImageURLFromHTML(url: url)
        if self.imageURL != nil {
            self.image = downloadImageFromURL(self.imageURL!)
        } else {
            self.image = #imageLiteral(resourceName: "errorstop")
        }
        if self.name == nil {
            self.name = "No name found"
        }
    }
    
    private func getPreviewNameFromHTML(url: String) -> String?{
        let myURL = URL(string: url)
        let searchFor = "meta property=\"og:title\" content="
        do {
            let myHTML = try String(contentsOf: myURL!, encoding: .ascii)
            let array = myHTML.components(separatedBy: "<")
            let filtered = array.filter {
                $0.contains(searchFor)
            }
            print(filtered)
            if filtered.count != 0 {
                let thingsToFilter = [searchFor, "\"", ">", " /", "\n"]
                var titleHTMLTag = filtered[0]
                for i in thingsToFilter {
                    titleHTMLTag = titleHTMLTag.replacingOccurrences(of: i, with: "")
                }
                print("The title is  \(titleHTMLTag)")
                return titleHTMLTag
            } else {
                let tryTag = array.filter {
                    $0.contains("title")
                }
                if tryTag.count != 0 {
                    let thingsToFilter = ["\"", ">", " /", "\n", "title"]
                    var titleHTMLTag = tryTag[0]
                    for i in thingsToFilter {
                        titleHTMLTag = titleHTMLTag.replacingOccurrences(of: i, with: "")
                    }
                    print("The title is  \(titleHTMLTag)")
                    return titleHTMLTag
                } else {
                    return nil
                }
            }
        } catch {
            print("Error")
            return nil
        }
    }

    
    private func getPreviewImageURLFromHTML(url: String) -> URL?{
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
                    return urlForImage
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
    
    private func downloadImageFromURL(_ url:URL) -> UIImage {
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
    
    
    
    enum Meal {
        case breakfast
        case lunch
        case dinner
        case snack
        case drink
    }
}




