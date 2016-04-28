//
//  Book.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/22/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation

struct Book {
    let title: String! //A book must have a title
    var author: String
    var description: String
    
    init(withTitle aTitle: String, author anAuthor: String = "Unknown author", description aDescripton: String = "No description") {
        title = aTitle
        author = anAuthor
        description = aDescripton
    }
    
    init(withGoogleJSONResponse response: [String: AnyObject], bookNumber: Int = 0) {
        guard let books = response["items"] as? [AnyObject] else { return }
        guard let book = books[bookNumber] as? [String: AnyObject] else { return }
        guard let volumeInfo = book["volumeInfo"] as? [String: AnyObject] else { return }
        
        title = volumeInfo["title"] as! String
        author = volumeInfo["authors"] as! String
        description = ""
    }
//    let title = json["items"][i]["volumeInfo"]["title"].stringValue
//    let author = json["items"][i]["volumeInfo"]["authors"][0].stringValue
//    let description = json["items"][i]["volumeInfo"]["description"].stringValue
    

}
