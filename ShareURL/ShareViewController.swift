//
//  ShareViewController.swift
//  ShareURL
//
//  Created by Christian Flanders on 9/14/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import CoreData

//@objc (ShareViewController)

class ShareViewController: UIViewController {
    private var urlString: String?
    private var textString: String?

    
    var selectedRecipe: RecipeFromURL!
    let store = PersistanceService.store
    var recipes = [RecipeFromURL]()
    
    
    @IBOutlet weak var addedView: UIView!
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecipes()
        recipes = store.fetchedRecipes
        
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        
        let contentTypeURL = kUTTypeURL as String

        
        for attachment in extensionItem.attachments as! [NSItemProvider] {
            attachment.loadItem(forTypeIdentifier: contentTypeURL , options: nil, completionHandler: { (results, error) in
                let url = results as! URL?
                self.urlString = url!.absoluteString

                print("!!!!!!!!!!! \(url!.absoluteString)")
            })
            
            
        }

            }
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidAppear(_ animated: Bool) {

        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        let date = NSDate()
        if urlString != nil {
            textString = getPreviewNameFromHTML(url: urlString!)
            store.storeRecipe(withTitle: textString!, url: urlString!, date: date)
        } else {
            print("Error storing url?")
        }
        func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                completion()
            }
        }
        UIView.animate(withDuration: 3, animations: {
            self.addedView.alpha = 0
            })
        delayWithSeconds(3) {
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context

//        UIView.animate(withDuration: 5, animations: {
//
//            })
//
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
                let thingsToFilter = [searchFor, "\"", ">", " /", "\n","data-react-helmet", "=true"]
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
                    let thingsToFilter = ["\"", ">", " /", "\n", "title","data-react-helmet","=true"]
                    var titleHTMLTag = tryTag[0]
                    for i in thingsToFilter {
                        titleHTMLTag = titleHTMLTag.replacingOccurrences(of: i, with: "")
                    }
                    print("The title is  \(titleHTMLTag)")
                    return titleHTMLTag
                } else {
                    return "No name found"
                }
            }
        } catch {
            print("Error")
            return "No name found"
        }
    }




}

