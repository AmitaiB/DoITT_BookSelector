//
//  BookSelector_TableViewController.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/21/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

typealias GoogleBooksCompletion = [Book]? -> ()

class BookSelectionViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let maxResults = 20
    var searchString: String?
    var bookSelection: Book?
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
        activityIndicator.startAnimating()
        
        requestGoogleBookListWithQuery(searchString, results: maxResults) { (responseBookList) in
            guard let bookList = responseBookList else {
                return
            }
            self.bookList = bookList
            self.activityIndicator.stopAnimating()
        }
    }
    
    func requestGoogleBookListWithQuery(searchString: String?, results: Int,  withCompletion completion: GoogleBooksCompletion) {
        guard let q = searchString else { fatalError(#function) }
        let params: [String: AnyObject] = ["q" : q,
                                           "langRestrict" : "en",
                                           "maxResults" : results,
                                           "printType" : "books",
                                           "orderBy" : "relevance"]

        request(.GET, "https://www.googleapis.com/books/v1/volumes", parameters: params, encoding: .URL, headers: nil)
            .validate()
            .responseSwiftyJSON { response in
                guard response.result.isSuccess else {
                    print("Error fetching book choices: \(response.result.error)")
                    completion(nil)
                    return
                }
                debugPrint(response.result.value)
                var tempBookList = [Book]()
                guard let json = response.result.value else { return }
                for i in 1...self.maxResults {
                    let title = json["items"][i]["volumeInfo"]["title"].stringValue
                    let author = json["items"][i]["volumeInfo"]["authors"][0].stringValue
                    let description = json["items"][i]["volumeInfo"]["description"].stringValue
                    
                    tempBookList.append(Book(title: title, author: author, description: description))
                }
                completion(tempBookList)
        }
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
