//
//  MainViewController.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/21/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleDisplayLabel: UILabel!
    @IBOutlet weak var authorDisplayLabel: UILabel!
    @IBOutlet weak var descriptionDisplayLabel: UILabel!
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if sender === searchButton && searchField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BookSelectionSegueID" {
            let bookSelectionVC = segue.destinationViewController as! BookSelectionViewController
            bookSelectionVC.searchString = searchField.text
        }
    }

    @IBAction func displaySelectionInMainViewController(segue: UIStoryboardSegue) {
        let bookSelectionVC = segue.sourceViewController as! BookSelectionViewController
        titleDisplayLabel.text = bookSelectionVC.bookSelection?.title
        authorDisplayLabel.text = bookSelectionVC.bookSelection?.author
        descriptionDisplayLabel.text = bookSelectionVC.bookSelection?.description
    }
}

