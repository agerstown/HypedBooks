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

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    tableView.registerClass(BookCell.self)
    tableView.dataSource = booksDataSource
    return tableView
  }()

  private let booksDataSource = BooksDataSource()

  private let noBooksLabel: UILabel = {
    let label = UILabel()
    label.text = "Не получилось загрузить книги :("
    label.font = UIFont.systemFont(ofSize: 22, weight: .thin)
    label.numberOfLines = 2
    label.isHidden = true
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupNoBooksLabel()

    booksDataSource.loadBooks(forPage: 1) { result in
      switch result {
      case .success:
        self.tableView.reloadData()
      case .error:
        self.noBooksLabel.isHidden = false
      case .noMoreBooks: ()
      }
    }
  }

  private func setupTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setupNoBooksLabel() {
    view.addSubview(noBooksLabel)
    noBooksLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

}
