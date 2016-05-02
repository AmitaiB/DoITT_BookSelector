//
//  Book.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/22/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation

protocol Book {
    var title: String { get set }
    var author: String { get set }
    var description: String { get set }
    
    func copyForUILabel() -> Book
}
