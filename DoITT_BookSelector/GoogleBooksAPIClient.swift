//
//  GoogleBooksAPIClient.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/28/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

typealias GoogleBooksCompletion = JSON -> ()

class GoogleBooksAPIClient {
    
    
    // configuration (state)
    var maxResults = 20 // pagination

    // singleton code
    static let sharedAPIClient = GoogleBooksAPIClient()
    private init() {}
    
    /**
     Hits the GoogleBooks API, sends the result to completion handler.
     
     - parameter searchString: The robust Google engine can apparantly handle any book metadata field (e.g., author, pub date, title). Returns immediately for null or empty strings. The default handler returns an Array of Book objects from the JSON response.
     */
    func requestGoogleBookListWithQuery(searchString: String?, completion: GoogleBooksCompletion) {
        
        guard let q = searchString else {
            print("*** error with \(self.dynamicType) in \(#function)")
            return
        }
        
        let params: [String: AnyObject] = ["q" : q,
                                           "langRestrict" : "en",
                                           "maxResults" : maxResults,
                                           "printType" : "books",
                                           "orderBy" : "relevance"]
        
        request(.GET, "https://www.googleapis.com/books/v1/volumes", parameters: params, encoding: .URL, headers: nil)
            .validate()
            .responseSwiftyJSON { response in
                guard response.result.isSuccess, let json = response.result.value else {
                    print("Error fetching book choices: \(response.result.error)")
                    completion(nil)
                    return
                }
                completion(json)
        }
    }
}
