//
//  CharacterCell.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 08.04.2021.
//

import UIKit

final class CharacterCell: UICollectionViewCell {
	static let reuseIdentifier: String = "CharacterCell"

	private lazy var image: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	private lazy var label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.backgroundColor = UIColor.marvelRed
		label.textColor = .white
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		contentView.layer.cornerRadius = 8
		contentView.layer.masksToBounds = true

		layer.shadowColor = UIColor.marvelBlack.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 4)
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.5
		layer.masksToBounds = false
		layer.shadowPath = UIBezierPath(roundedRect: bounds,
										cornerRadius: contentView.layer.cornerRadius).cgPath

		contentView.addSubview(image)
		contentView.addSubview(label)
		NSLayoutConstraint.activate([
			image.topAnchor.constraint(equalTo: contentView.topAnchor),
			image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}

	func configure(with model: CharacterViewModel) {
		image.setImage(by: model.avatar)
		label.text = model.name
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		image.image = nil
		label.text = nil
	}
}
