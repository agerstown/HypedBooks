//
//  Router.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/6/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class Router {

  static let shared = Router()

  private let window = UIWindow(frame: UIScreen.main.bounds)

  func setRootViewController() {
    showBooksViewController()
  }

  private func showBooksViewController() {
    let booksViewController = BooksViewController()
    let navigation = UINavigationController(rootViewController: booksViewController)
    setRootViewController(navigation, forWindow: window, animated: false)
  }

  private func setRootViewController(_ controller: UIViewController, forWindow window: UIWindow, animated: Bool) {
    window.rootViewController = controller
    window.makeKeyAndVisible()
  }

}
