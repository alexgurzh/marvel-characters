//
//  CharacterDetailsViewController.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 08.04.2021.
//

import UIKit

final class CharacterDetailsViewController: MarvelViewController {
	private let presenter: CharacterDetailsPresenter
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .clear
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = UIView()
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		return tableView
	}()

	private lazy var headerView: UIView = {
		let headerSize = CGSize(width: view.bounds.width, height: Constants.headerHeight)
		let headerView = UIImageView(frame: .init(origin: .zero, size: headerSize))
		headerView.contentMode = .scaleAspectFill
		headerView.clipsToBounds = true
		headerView.setImage(by: presenter.model.avatar)
		return headerView
	}()

	enum Constants {
		static let headerHeight: CGFloat = 360
	}

	init(router: Router, model: CharacterDetailsViewModel) {
		presenter = CharacterDetailsPresenter(model: model)
		super.init(router: router)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		view.backgroundColor = .white
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	private func setupNavBar() {
		let titleView = UILabel()
		titleView.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
		titleView.backgroundColor = UIColor.marvelRed
		titleView.textColor = .white
		titleView.text = presenter.model.name
		navigationItem.titleView = titleView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupNavBar()
	}

	override func viewSafeAreaInsetsDidChange() {
		super.viewSafeAreaInsetsDidChange()
		tableView.contentInset = view.safeAreaInsets
		tableView.contentInset.top = 0
	}
}

// MARK: - UITableViewDataSource
extension CharacterDetailsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		presenter.sectionsCount
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.rowsCount(for: section)
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		presenter.sectionTitle(for: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.text = presenter.rowText(for: indexPath)
		cell.selectionStyle = .none
		return cell
	}
}
