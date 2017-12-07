//
//  UITableView+Extensions.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/7/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

extension UITableView {
  func dequeue<T: UITableViewCell>(_ type: T.Type) -> T {
    return dequeueReusableCell(withIdentifier: String(describing: type)) as! T
  }

  func registerClass<T: UITableViewCell>(_ type: T.Type) {
    register(type, forCellReuseIdentifier: String(describing: type))
  }
}
