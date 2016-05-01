//
//  MainViewController.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/21/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

internal let kSearchResultsCellReuseID = "searchResultsCellReuseID"

class BookSearchViewController: UIViewController {
    
    @IBOutlet weak var titleDisplayLabel: UILabel!
    @IBOutlet weak var authorDisplayLabel: UILabel!
    @IBOutlet weak var descriptionDisplayLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    let apiClient = GoogleBooksAPIClient.sharedAPIClient
    let maxResults = 20
    let displayLabelCornerRadius: CGFloat = 5
    let timeoutInterval = 5.0
    var searchResults = [Book]() {
        didSet {
            if searchResults.isEmpty {
                resultsTableView.hidden = true
                view.alpha = 1.0
            } else {
                resultsTableView.hidden = false
                resultsTableView.reloadData()
                view.alpha = 0.5
            }
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCornersOfViews([titleDisplayLabel, authorDisplayLabel, descriptionDisplayLabel],
                            byAmount: displayLabelCornerRadius)
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
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        resultsTableView.hidden = true
        
        let thisBook = searchResults[indexPath.row].selfWithUILabelShift()
        
        titleDisplayLabel.text = thisBook.title
        authorDisplayLabel.text = thisBook.author
        descriptionDisplayLabel.text = thisBook.description
        
        view.alpha = 1.0
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
    
    
    // MARK: - Helpers
    
    func populateDataSourceFromNetworkCall(withSearchString searchString: String) {
        activityIndicator.startAnimating()
        apiClient.setTimeoutInterval(timeoutInterval)
        apiClient.maxResults = maxResults
        
        apiClient.requestGoogleBookListWithQuery(searchString) { json in
            var tempBookList = [Book]()
            for i in 1...self.maxResults {
                let title       = json["items"][i]["volumeInfo"]["title"].stringValue
                let author      = json["items"][i]["volumeInfo"]["authors"][0].stringValue
                let description = json["items"][i]["volumeInfo"]["description"].stringValue
                tempBookList.append(Book(withTitle: title, author: author, description: description))
            }
            self.searchResults = tempBookList
            self.activityIndicator.stopAnimating()
        }
    }
    
    func handleSearchError(error: NSError, message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func roundCornersOfViews(views: [UIView], byAmount radius: CGFloat) {
        for view in views {
            view.layer.cornerRadius = radius
            view.clipsToBounds = true
        }
    }
}