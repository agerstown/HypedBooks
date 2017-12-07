//
//  Target.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/7/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Alamofire

enum Target {
  case getPopularBooks(page: Int)
}

extension Target {
  private var baseURL: String {
    return "https://api.bookmate.com/api/v5"
  }

  private var path: String {
    switch self {
    case .getPopularBooks:
      return "/books/popular"
    }
  }

  var fullPath: String {
    return baseURL + path
  }

  var queryParams: [String: Any]? {
    switch self {
    case .getPopularBooks(let page):
      return ["page": page]
    }
  }

  var method: HTTPMethod {
    switch self {
    case .getPopularBooks:
      return .get
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .getPopularBooks:
      return nil
    }
  }
}
