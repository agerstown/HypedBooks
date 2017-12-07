//
//  BooksViewController.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/6/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit
import SnapKit

class BooksViewController: UIViewController {

  private let tableView = UITableView()
  private let booksDataSource = BooksDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()

    booksDataSource.loadBooks(forPage: 1) { success in
      self.tableView.reloadData()
    }
  }

  private func setupTableView() {
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

    tableView.registerClass(BookCell.self)

    tableView.dataSource = booksDataSource

    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
