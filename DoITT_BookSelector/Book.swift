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
    let ISBN: String? //If the ISBN is known, it cannot change
    var author: String = "Unknown author"
    var description: String = "No description"
}
