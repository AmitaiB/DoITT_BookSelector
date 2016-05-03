//
//  ImageAPIClient.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 5/3/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

typealias ImageCompletion = UIImage -> ()

class ImageAPIClient {
    // singleton code
    static let sharedImageClient = ImageAPIClient()
    private init() {}
    
    func imageForURL(url: String, completion: ImageCompletion) {
        request(.GET, url)
        .responseImage { response in
            if response.result.isSuccess, let image = response.result.value {
                completion(image)
            }
        }
        
    }
}
