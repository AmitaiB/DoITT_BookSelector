//
//  CommonResources.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/28/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

// errors
internal func DBLG(thisFunction: AnyObject) {
    print("*** error in \(thisFunction)  (ln. \(#line))***")
}

// colors

 /// For active backgrounds (in switches, scrollviews, etc.)
internal let allportsBlueColor = UIColor(red:0.00, green:0.45, blue:0.68, alpha:1.00)

/// For NavigationBar, menus, and other Things That Don't Move
internal let onyxBlackColor = UIColor(red:0.06, green:0.06, blue:0.06, alpha:1.00)

 /// White, with good PR, the background color that makes everything else shine.
internal let romanceWhiteColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.00)
