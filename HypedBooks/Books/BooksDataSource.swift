//
//  BooksDataSource.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/6/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import SwiftyJSON
import UIKit

class BooksDataSource: NSObject {

  private var books: [Book] = []

  func loadBooks(forPage page: Int, completion: @escaping (_ success: Bool) -> Void) {
    NetworkingManager.shared.makeRequest(target: .getPopularBooks(page: 1)) { response in
      guard let value = response.result.value else {
        completion(false)
        return
      }
      
      let json = JSON(value)
      let booksJSON = json["books"].arrayValue
      self.books = booksJSON.flatMap { Book.fromJSON($0) }
      completion(true)
    }
  }
}

// MARK: - UITableViewDataSource
extension BooksDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(BookCell.self)
    let book = books[indexPath.row]
    cell.configure(withBook: book)
    return cell
  }
}
