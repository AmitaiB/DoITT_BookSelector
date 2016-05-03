//
//  MainViewController.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/21/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import AlamofireImage

private let kSearchResultsCellReuseID = "searchResultsCellReuseID"

class BookSearchViewController: UIViewController {
    // Output display labels
    @IBOutlet weak var titleDisplayLabel: UILabel!
    @IBOutlet weak var authorDisplayLabel: UILabel!
    @IBOutlet weak var longDescriptionView: UITextView!
    
    // Search related
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    private let apiClient = GoogleBooksAPIClient.sharedAPIClient
    private let maxResults = 20
    private let displayLabelCornerRadius: CGFloat = 5
    private let timeoutInterval = 5.0
    private var searchResults = [Book]() {
        didSet {
            if searchResults.isEmpty {
                resultsTableView.hidden = true
                blurView.hidden = true
                view.alpha = 1.0
            } else {
                blurView.hidden = false
                resultsTableView.hidden = false
                resultsTableView.reloadData()
                view.alpha = 0.5
            }
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCornersOfViews([titleDisplayLabel, authorDisplayLabel, longDescriptionView], byAmount: displayLabelCornerRadius)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


// MARK: - UITableViewDataSource

extension BookSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kSearchResultsCellReuseID, forIndexPath: indexPath)
        
        let thisBook = searchResults[indexPath.row]
        
        cell.textLabel?.text = thisBook.author
        cell.detailTextLabel?.text = thisBook.title
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension BookSearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // search bar
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        resultsTableView.hidden = true
        
        let thisBook = searchResults[indexPath.row]
        searchResults.removeAll()
        
        titleDisplayLabel.text = " " + thisBook.title + " "
        authorDisplayLabel.text = " " + thisBook.author + " "
        longDescriptionView.text = " " + thisBook.description + " "
        
        // Add image
        if let imageString = thisBook.imageURL, let bookImageURL = NSURL(string: imageString) {
            let bookImageView = UIImageView()
            bookImageView.backgroundColor = UIColor.orangeColor()
            longDescriptionView.addSubview(bookImageView)
            longDescriptionView.bringSubviewToFront(bookImageView)
            bookImageView.frame = CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: 100, height: 130))
            bookImageView.af_setImageWithURL(bookImageURL)
            
            let imagePath = UIBezierPath(rect: bookImageView.frame)
            longDescriptionView.textContainer.exclusionPaths = [imagePath]
        }
        
        
        view.alpha = 1.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - UISearchBarDelegate

extension BookSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            resultsTableView.hidden = false
            
            populateDataSourceFromNetworkCall(withSearchString: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        resultsTableView.hidden = true
    }
    
    // MARK: - helpers
    
    func populateDataSourceFromNetworkCall(withSearchString searchString: String) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        apiClient.setTimeoutInterval(timeoutInterval)
        apiClient.maxResults = maxResults
        
        apiClient.requestGoogleBookListWithQuery(searchString) { json in
            var tempBookList = [Book]()
            for i in 1...self.maxResults {
                if let newBook = GBook(withGoogleVolumeResponse: json, withOptions: [kIndexKey: i]) {
                    tempBookList.append(newBook)
                }
            }
            self.searchResults = tempBookList
            self.activityIndicator.stopAnimating()
        }
    }
    
    func roundCornersOfViews(views: [UIView], byAmount radius: CGFloat) {
        for view in views {
            view.layer.cornerRadius = radius
            view.clipsToBounds = true
        }
    }
}