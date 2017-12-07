//
//  JSONable.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/7/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import SwiftyJSON

protocol JSONable {
  static func fromJSON(_ json: JSON) -> Self?
}
