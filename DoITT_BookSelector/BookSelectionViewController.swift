//
//  BookSelector_TableViewController.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/21/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

class BookSelectionViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let apiClient = GoogleBooksAPIClient.sharedAPIClient
    let maxResults = 20
    var searchString: String?
    var bookSelection: Book?
    
    // datasource object
    var bookList = [Book]() {
        didSet {
            if bookList.isEmpty {
                tableView.alpha = 0
            } else {
                tableView.alpha = 1
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDataSourceFromNetworkCall()
    }
    
    /// Request, get back a JSON response, feed response to completion-compliant handler, set local datasource.
    func populateDataSourceFromNetworkCall() {
        activityIndicator.startAnimating()
        
        apiClient.maxResults = maxResults
        apiClient.requestGoogleBookListWithQuery(searchString) { json in
            var tempBookList = [Book]()
            for i in 1...self.maxResults {
                let title       = json["items"][i]["volumeInfo"]["title"].stringValue
                let author      = json["items"][i]["volumeInfo"]["authors"][0].stringValue
                let description = json["items"][i]["volumeInfo"]["description"].stringValue
                tempBookList.append(Book(withTitle: title, author: author, description: description))
            }
            self.bookList = tempBookList
            self.activityIndicator.stopAnimating()
        }
        
        // TODO: timeout code goes here.
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            bookSelection = bookList[indexPath.row]
        }
    }
}

// MARK: - UITableViewDataSource

extension BookSelectionViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let book = bookList[indexPath.row]
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.description
        return cell
    }
}
