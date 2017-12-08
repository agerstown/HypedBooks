//
//  String+Decoding.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/8/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Foundation

extension String {
  func decodedFromHtml() -> String? {
    guard let data = data(using: .unicode) else { return nil }
    let decodedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html],
                                                documentAttributes: nil).string
    return decodedString
  }
}
