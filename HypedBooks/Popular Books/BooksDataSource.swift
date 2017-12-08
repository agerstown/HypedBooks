//
//  BooksDataSource.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/6/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import SwiftyJSON
import UIKit

enum BooksLoadingResult {
  case success
  case error
  case noMoreBooks
}

class BooksDataSource: NSObject {

  private var books: [Book] = []

  private var hasNextPage = true
  private var pageNumber = 1
  private var loading = false

  private let bottomActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  func loadBooks(forPage page: Int, completion: @escaping (_ result: BooksLoadingResult) -> Void) {
    loading = true
    NetworkingManager.shared.makeRequest(target: .getPopularBooks(page: page)) { response in
      self.loading = false
      switch response.result {
        case .failure:
          completion(.error)
        case .success:
          guard let value = response.result.value else {
            completion(.error)
            return
          }
          let json = JSON(value)
          let booksJSON = json["books"].arrayValue
          guard !booksJSON.isEmpty else {
            self.hasNextPage = false
            completion(.noMoreBooks)
            return
          }
          if page == 1 { self.books.removeAll() }
          self.books += booksJSON.flatMap { Book.fromJSON($0) }
          self.pageNumber = page
          completion(.success)
      }
    }
  }

  func resetState() {
    hasNextPage = true
    pageNumber = 1
    loading = false
  }

  private func loadMoreBooksIfNecessary(tableView: UITableView, indexPath: IndexPath) {
    // если сейчас будет отображаться 3-я с конца ячейка, пора грузить следующую страницу с книгами
    guard tableView.numberOfRows(inSection: indexPath.section) - 3 == indexPath.row else { return }
    guard hasNextPage, !loading else { return }

    tableView.tableFooterView = bottomActivityIndicator
    bottomActivityIndicator.startAnimating()

    loadBooks(forPage: pageNumber + 1) { result in
      self.bottomActivityIndicator.stopAnimating()
      switch result {
      case .success:
        tableView.reloadData()
      case .noMoreBooks, .error:
        tableView.tableFooterView = nil
      }
    }
  }

  func getBook(forIndex index: Int) -> Book? {
    guard index < books.count else { return nil }
    return books[index]
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
    loadMoreBooksIfNecessary(tableView: tableView, indexPath: indexPath)
    return cell
  }
}
