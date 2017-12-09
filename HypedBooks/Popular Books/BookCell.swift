//
//  BookCell.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/7/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit
import SnapKit
import Nuke

class BookCell: UITableViewCell {

  // MARK: - Views
  private let view: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 8
    view.addShadow()
    return view
  }()

  let coverImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 4
    imageView.layer.masksToBounds = true
    return imageView
  }()

  private lazy var bookDetailsStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, annotationLabel, authorsLabel])
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.numberOfLines = 2
    return label
  }()

  let annotationLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.numberOfLines = 3
    return label
  }()

  let authorsLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .light)
    label.textColor = .lightGray
    return label
  }()

  // MARK: - Initialization
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none

    setupBackgroundView()
    setupCoverImageView()
    setupBookDetailsStackView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Views setup
  private func setupBackgroundView() {
    contentView.addSubview(view)
    view.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(16)
      make.top.bottom.equalToSuperview().inset(12)
    }
  }

  private func setupCoverImageView() {
    view.addSubview(coverImageView)
    coverImageView.snp.makeConstraints { make in
      make.left.top.bottom.equalToSuperview().inset(16)
      make.width.equalTo(60)
    }
  }

  private func setupBookDetailsStackView() {
    view.addSubview(bookDetailsStackView)
    bookDetailsStackView.snp.makeConstraints { make in
      make.right.top.bottom.equalToSuperview().inset(16)
      make.left.equalTo(coverImageView.snp.right).offset(16)
    }
  }
}
