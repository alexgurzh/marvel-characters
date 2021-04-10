//
//  CharactersViewController.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 03.04.2021.
//

import UIKit

final class CharactersViewController: MarvelViewController {
	private let interactor = CharactersInteractor()
	private var models: [CharacterViewModel] = []

	private lazy var collectionView: UICollectionView = {
		let collectionFlowLayout = UICollectionViewFlowLayout()
		collectionFlowLayout.scrollDirection = .vertical
		collectionFlowLayout.minimumInteritemSpacing = Constants.itemSpacing
		collectionFlowLayout.minimumLineSpacing = Constants.itemSpacing
		collectionFlowLayout.sectionInset = Constants.layoutMargins
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
		collectionView.backgroundColor = .white
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.contentInsetAdjustmentBehavior = .always
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
		return collectionView
	}()

	private lazy var titleView: UIView = {
		let titleView = UIImageView(image: UIImage(named: "Marvel_Logo"))
		titleView.contentMode = .scaleAspectFit
		return titleView
	}()

	private enum Constants {
		static let numberOfColumns: Int = 2
		static let itemSpacing: CGFloat = 24
		static let layoutMargins: UIEdgeInsets = .init(top: Constants.itemSpacing,
													   left: Constants.itemSpacing,
													   bottom: Constants.itemSpacing,
													   right: Constants.itemSpacing)
	}

	private func setupUI() {
		view.backgroundColor = .white
		view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	private func updateCollectionViewLayout() {
		guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
			return
		}
		let safeAreaInsets = view.safeAreaInsets.left + view.safeAreaInsets.right
		let columnWidth = (view.bounds.width - safeAreaInsets) / CGFloat(Constants.numberOfColumns)
		let margins = Constants.itemSpacing + Constants.itemSpacing/2 * CGFloat(Constants.numberOfColumns - 1)
		let itemWidth = columnWidth - margins
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		flowLayout.invalidateLayout()
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		interactor.subscribe { [weak self] models, updates in
			guard let self = self, !updates.isEmpty, let models = models as? [CharacterViewModel] else {
				return
			}
			self.models = models
			self.collectionView.performBatchUpdates {
				for update in updates {
					let indexPaths = update.indexes.map { IndexPath(item: $0, section: 0) }
					switch update.action {
					case .delete:
						self.collectionView.deleteItems(at: indexPaths)
					case .insert:
						self.collectionView.insertItems(at: indexPaths)
					case .reload:
						self.collectionView.reloadItems(at: indexPaths)
					}
				}
			}
		}
		interactor.load(fromStart: true)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.titleView = titleView
	}

	override func viewSafeAreaInsetsDidChange() {
		super.viewSafeAreaInsetsDidChange()
		updateCollectionViewLayout()
	}
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		models.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier,
													  for: indexPath)
		if let characterCell = cell as? CharacterCell {
			characterCell.configure(with: models[indexPath.row])
		}
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let detailsModel = interactor.getCharacterDetails(by: models[indexPath.row].id) else {
			return
		}
		router.openCharacterDetails(detailsModel)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetLoadEdge = scrollView.contentSize.height - scrollView.frame.size.height * 1.5
		if (scrollView.contentOffset.y > offsetLoadEdge) {
			interactor.load()
		}
	}
}
