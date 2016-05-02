//
//  GBook.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 5/2/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class TestClass {
    
}

internal let kIndexKey = "index"

struct GBook: Book {
    var title: String
    var author: String
    var description: String
    
    let defaultAuthor = " No data "
    let defaultDescription  = " No description "
    
    init(withTitle aTitle: String, author anAuthor: String?, description aDescripton: String?) {
        title = " \(aTitle) "
        if let unwrappedAuthor = anAuthor {
            author = " \(unwrappedAuthor) "
        } else {
            author = defaultAuthor
        }
        
        if let unwrappedDescription = aDescripton {
            description = " \(unwrappedDescription) "
        } else {
            description = defaultAuthor
        }
    }
    
    init?(withGoogleVolumeResponse json: JSON, withOptions opts: [String: AnyObject]? = [kIndexKey : 0]) {
        
        guard let options = opts,
            i = options[kIndexKey] as? Int
            else { return nil }
        
        title       = json["items"][i]["volumeInfo"]["title"].stringValue
        author      = json["items"][i]["volumeInfo"]["authors"][0].stringValue
        description = json["items"][i]["volumeInfo"]["description"].stringValue
        
        // Books must have titles.
        if title.isEmpty { return nil }
    }
    
    func allProperties() -> [String] {
        return [title, author, description]
    }

    /// Returns a copy of the Book, with a single space of padding for each property (string).
    func copyForUILabel() -> Book {
        return GBook(withTitle: " \(title) ", author: " \(author) ", description: " \(description) ")
    }
}

