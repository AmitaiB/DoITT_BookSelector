//
//  MainViewController.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/21/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

/**
 This VC performs validation (non-empty string), and displays the selected info.
 */

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleDisplayLabel: UILabel!
    @IBOutlet weak var authorDisplayLabel: UILabel!
    @IBOutlet weak var descriptionDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if sender === searchButton && searchField.text?.characters.count == 0 {
            searchField.placeholder = "Search string??"
            return false
        }
        searchField.placeholder = nil
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let bookSelectorVC = segue.destinationViewController as? BookSelector_TableViewController {
            bookSelectorVC.searchString = searchField.text
        }
    }

    @IBAction func displaySelectionInMainViewController(segue: UIStoryboardSegue) {
        guard let bookSelectionVC = segue.sourceViewController as? BookSelector_TableViewController else { return }
        titleDisplayLabel.text = bookSelectionVC.bookSelection?.title
        authorDisplayLabel.text = bookSelectionVC.bookSelection?.author
        descriptionDisplayLabel.text = bookSelectionVC.bookSelection?.description
    }
    
    

}

