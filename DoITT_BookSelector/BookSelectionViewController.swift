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


class BookSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchString: String?
    var bookSelection: Book?
    var bookList = [Book]() {
        didSet {
            tableView.alpha = (bookList.count == 0) ? 0 : 1
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alpha = 0
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        
        //Make Network request here.
        if let qString = searchString {
            requestGoogleBookListWithQuery(qString) { responseBookList in
                guard let bookList = responseBookList else { return }
                self.bookList = bookList
                self.activityIndicator.stopAnimating()
            }
        } else {
            print("Error, malformed request string.")
        }
    }
    
    
    func requestGoogleBookListWithQuery(searchString: String, withCompletion completion: ([Book]?)->()) {
        let params: [String: AnyObject] = ["q" : searchString,
                                           "langRestrict" : "en",
                                           "maxResults" : 20,
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
                for i in 1...10 {
                    let title = json["items"][i]["volumeInfo"]["title"].stringValue
                    let author = json["items"][i]["volumeInfo"]["authors"][0].stringValue
                    let description = json["items"][i]["volumeInfo"]["description"].stringValue

                    tempBookList.append(Book(title: title, author: author, description: description))
                }
                completion(tempBookList)
        }
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

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
    
    
    // MARK: UITableView Delegate
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError(#function) }
        bookSelection = bookList[indexPath.row]
    }

}
