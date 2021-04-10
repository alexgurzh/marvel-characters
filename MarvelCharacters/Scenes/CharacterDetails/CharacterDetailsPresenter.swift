//
//  CharacterDetailsPresenter.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 09.04.2021.
//

import Foundation

struct CharacterDetailsPresenter {
	let model: CharacterDetailsViewModel

	init(model: CharacterDetailsViewModel) {
		self.model = model
	}

	var sectionsCount: Int {
		1 + model.contents.count
	}

	func rowsCount(for section: Int) -> Int {
		switch section {
		case 0:
			return model.description != nil ? 1 : 0
		default:
			return getContentList(for: section).list.count
		}
	}

	func sectionTitle(for section: Int) -> String? {
		switch section {
		case 0:
			return rowsCount(for: section) > 0 ? "Description" : nil
		default:
			return getContentList(for: section).name
		}
	}

	func rowText(for indexPath: IndexPath) -> String? {
		switch indexPath.section {
		case 0:
			return model.description
		default:
			return getContentList(for: indexPath.section).list[indexPath.row]
		}
	}

	private func getContentList(for section: Int) -> CharacterDetailsViewModel.ContentList {
		model.contents[section - 1]
	}
}
