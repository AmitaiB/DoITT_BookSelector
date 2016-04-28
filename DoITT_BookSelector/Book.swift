//
//  Book.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/22/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation

struct Book {
    var title: String! //A book must have a title
    var author: String! = "No data"
    var description: String! = "No description"
    
    init(withTitle aTitle: String, author anAuthor: String?, description aDescripton: String?) {
        title = aTitle
        if let unwrappedAuthor = anAuthor {
            author = unwrappedAuthor
        }
        if let unwrappedDescription = aDescripton {
            description = unwrappedDescription
        }
    }
    
    init?(withGoogleJSONResponse response: [String: AnyObject], bookNumber: Int = 0) {
        // First, drill down to the VolumeInfo
        guard let books = response["items"] as? [AnyObject] else { return nil }
        guard let book = books[bookNumber] as? [String: AnyObject] else { return nil }
        guard let volumeInfo = book["volumeInfo"] as? [String: AnyObject] else { return nil }
        
        // Next, get this book's info
        // Title - required
        guard let aTitle = volumeInfo["title"] as? String else { return nil}
        title = aTitle
        
        // Author - optional
        if let authors = volumeInfo["authors"] as? [String] {
            if let firstAuthor = authors.first {
                author = firstAuthor
            }
        } else {
            author = "No data"
        }
        
        // Description - optional
        if let aDescription = volumeInfo["description"] as? String {
            description = aDescription
        } else {
            description = "No description"
        }
    }
}
