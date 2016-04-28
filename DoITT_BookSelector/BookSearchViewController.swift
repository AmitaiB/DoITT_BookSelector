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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    var searchResults = [Book]()
    let apiClient = GoogleBooksAPIClient.sharedAPIClient
    let maxResults = 20
    
    
    @IBOutlet weak var titleDisplayLabel: UILabel!
    @IBOutlet weak var authorDisplayLabel: UILabel!
    @IBOutlet weak var descriptionDisplayLabel: UILabel!
}

// MARK: - UITableViewDataSource

extension BookSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kSearchResultsCellReuseID, forIndexPath: indexPath)
        
        let thisBook = searchResults[indexPath.row]
        
        cell.textLabel?.text = thisBook.title
        cell.detailTextLabel?.text = thisBook.author
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension BookSearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        let thisBook = searchResults[indexPath.row]
        
        titleDisplayLabel.text = thisBook.title
        authorDisplayLabel.text = thisBook.author
        descriptionDisplayLabel.text = thisBook.description
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
            
            /// TODO: Network call for search query string -> update dataSource obj in completion, reloadData
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        resultsTableView.hidden = true
    }
    
    // MARK: - Helpers
    
    func handleSearchError(error: NSError) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}