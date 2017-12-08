//
//  BookViewController.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/8/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit
import SnapKit

class BookViewController: UIViewController {

  private let bookTitle: String
  private let bookID: String

  private lazy var bookLink = "https://bookmate.com/books/\(bookID)"

  // MARK: - UI elements
  private let bookPageWebView = UIWebView()
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  private let loadingErrorLabel: UILabel = {
    let label = UILabel()
    label.text = "Не получилось загрузить книгу :("
    label.font = UIFont.systemFont(ofSize: 22, weight: .thin)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()

  init(bookTitle: String, bookID: String) {
    self.bookTitle = bookTitle
    self.bookID = bookID

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    bookPageWebView.delegate = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }

    title = bookTitle

    setupBookPageWebView()
    setupActivityIndicator()

    loadBookPage()
  }

  // MARK: - Views setup
  private func setupBookPageWebView() {
    bookPageWebView.delegate = self

    view.addSubview(bookPageWebView)
    bookPageWebView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setupActivityIndicator() {
    let barButton = UIBarButtonItem(customView: activityIndicator)
    navigationItem.rightBarButtonItem = barButton
  }

  private func setupLoadingErrorLabel() {
    view.addSubview(loadingErrorLabel)
    loadingErrorLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(200)
    }
  }

  // MARK: - Book loading
  private func loadBookPage() {
    guard let url = URL(string: bookLink) else {
      setupLoadingErrorLabel()
      return
    }
    activityIndicator.startAnimating()
    let bookRequest = URLRequest(url: url)
    bookPageWebView.loadRequest(bookRequest)
  }
}

// MARK: - UIWebViewDelegate
extension BookViewController: UIWebViewDelegate {
  func webViewDidFinishLoad(_ webView: UIWebView) {
    activityIndicator.stopAnimating()
  }

  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    activityIndicator.stopAnimating()
  }
}
