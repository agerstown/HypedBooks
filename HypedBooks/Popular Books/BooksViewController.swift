//
//  BooksViewController.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/6/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit
import SnapKit
import Nuke

class BooksViewController: UIViewController {

  private let booksDataSource = BooksDataSource()

  // MARK: - UI elements
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    tableView.registerClass(BookCell.self)
    tableView.dataSource = self
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
  private let bottomActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
        self.noBooksLabel.isHidden = true
      case .error:
        self.noBooksLabel.isHidden = false
      case .noMoreBooks: ()
      }
      self.tableView.reloadData()
    }
  }

  private func loadMoreBooksIfNecessary(row: Int) {
    // если сейчас будет отображаться 3-я с конца ячейка, пора грузить следующую страницу с книгами
    guard booksDataSource.numberOfBooks - 3 == row else { return }

    tableView.tableFooterView = bottomActivityIndicator
    bottomActivityIndicator.startAnimating()
    booksDataSource.loadMoreBooks { result in
      self.bottomActivityIndicator.stopAnimating()
      switch result {
      case .success:
        self.tableView.reloadData()
      case .noMoreBooks, .error:
        self.tableView.tableFooterView = nil
      }
    }
  }

}

// MARK: - UITableViewDataSource
extension BooksViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return booksDataSource.numberOfBooks
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let book = booksDataSource.getBook(forIndex: indexPath.row) else { return UITableViewCell() }
    let cell = tableView.dequeue(BookCell.self)
    configureCell(cell, withBook: book)
    loadMoreBooksIfNecessary(row: indexPath.row)
    return cell
  }

  private func configureCell(_ cell: BookCell, withBook book: Book) {
    cell.coverImageView.image = book.placeholder
    if let url = URL(string: book.smallCoverURL) {
      Nuke.loadImage(with: url, into: cell.coverImageView)
    }

    cell.titleLabel.text = book.title
    cell.annotationLabel.text = book.annotation
    cell.authorsLabel.text = book.authors
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
