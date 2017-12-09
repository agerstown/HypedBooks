//
//  BooksDataSource.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/6/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import SwiftyJSON

enum BooksLoadingResult {
  case success
  case error
  case noMoreBooks
}

class BooksDataSource {

  private var books: [Book] = []

  var numberOfBooks: Int {
    return books.count
  }

  private var hasNextPage = true
  private var pageNumber = 1
  private var loading = false

  func resetState() {
    hasNextPage = true
    pageNumber = 1
    loading = false
    books = []
  }

  func getBook(forIndex index: Int) -> Book? {
    guard index >= 0, index < books.count else { return nil }
    return books[index]
  }

  // MARK: - Data loading
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

  func loadMoreBooks(completion: @escaping (_ result: BooksLoadingResult) -> Void) {
    guard hasNextPage, !loading else { return }

    loadBooks(forPage: pageNumber + 1) { result in
      completion(result)
    }
  }
}
