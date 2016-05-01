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
    
    func allProperties() -> [String] {
        return [title, author, description]
    }
    
    init(withTitle aTitle: String, author anAuthor: String?, description aDescripton: String?) {
        title = aTitle
        if let unwrappedAuthor = anAuthor {
            author = unwrappedAuthor
        }
        if let unwrappedDescription = aDescripton {
            description = unwrappedDescription
        }
    }
}
