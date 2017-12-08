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

  private let booksDataSource = BooksDataSource()

  // MARK: - UI elements
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    tableView.registerClass(BookCell.self)
    tableView.dataSource = booksDataSource
    tableView.delegate = self
    return tableView
  }()

  private let noBooksLabel: UILabel = {
    let label = UILabel()
    label.text = "Не получилось загрузить книги :("
    label.font = UIFont.systemFont(ofSize: 22, weight: .thin)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.isHidden = true
    return label
  }()

  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  private let refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Popular books"

    setupTableView()
    setupNoBooksLabel()
    setupActivityIndicator()

    activityIndicator.startAnimating()
    loadBooks() {
      self.activityIndicator.removeFromSuperview()
    }
  }

  // MARK: - Views setup
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    setupRefreshControl()
  }

  private func setupRefreshControl() {
    refreshControl.addTarget(self, action: #selector(refreshControllPulled), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }

  private func setupNoBooksLabel() {
    view.addSubview(noBooksLabel)
    noBooksLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  private func setupActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  // MARK: - Actions
  @objc private func refreshControllPulled() {
    booksDataSource.resetState()
    loadBooks() {
      self.refreshControl.endRefreshing()
    }
  }

  // MARK: - Data loading
  private func loadBooks(completion: @escaping () -> Void) {
    booksDataSource.loadBooks(forPage: 1) { result in
      completion()
      switch result {
      case .success:
        self.tableView.reloadData()
      case .error:
        self.noBooksLabel.isHidden = false
      case .noMoreBooks: ()
      }
    }
  }

}

// MARK: - UITableViewDelegate
extension BooksViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let book = booksDataSource.getBook(forIndex: indexPath.row) else { return }
    let bookViewController = BookViewController(bookTitle: book.title, bookID: book.id)
    navigationController?.pushViewController(bookViewController, animated: true)
  }
}
