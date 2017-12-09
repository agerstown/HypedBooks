//
//  Book.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/7/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Book {
  let id: String
  let title: String
  let annotation: String
  let authors: String
  let smallCoverURL: String
  let placeholderData: Data?

  init(id: String, title: String, annotation: String, authors: String, smallCoverURL: String, placeholderData: Data?) {
    self.id = id
    self.title = title
    self.annotation = annotation
    self.authors = authors
    self.smallCoverURL = smallCoverURL
    self.placeholderData = placeholderData
  }
}

// MARK: - JSONable
extension Book: JSONable {
  static func fromJSON(_ json: JSON) -> Book? {
    guard let id = json["uuid"].string,
      let title = json["title"].string,
      let annotation = json["annotation"].string,
      let authors = json["authors"].string,
      let smallCoverURL = json["cover"]["small"].string else { return nil }

    let placeholderData = Data(base64Encoded: json["cover"]["placeholder"].stringValue)

    var decodedAnnotation = annotation.decodedFromHtml() ?? annotation
    decodedAnnotation = decodedAnnotation.trimmingCharacters(in: .whitespacesAndNewlines)

    return Book(id: id,
                title: title,
                annotation: decodedAnnotation,
                authors: authors,
                smallCoverURL: smallCoverURL,
                placeholderData: placeholderData)
  }
}
