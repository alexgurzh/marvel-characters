//
//  StorageServiceSpy.swift
//  MarvelCharactersTests
//
//  Created by Alexander Gurzhiev on 10.04.2021.
//

import Foundation
@testable import MarvelCharacters

final class StorageServiceSpy: StorageService {
	var viewModels: [ViewModel] = []
	var updatesForViewModels: [DataUpdate] = []
	var savedModels: [Decodable] = []
	var didDeleteAll: Bool = false

	func fetch(_ vmType: ViewModel.Type, by id: Int) -> ViewModel? {
		let viewModel = viewModels[id]
		guard type(of: viewModel) == vmType else {
			return nil
		}
		return viewModel
	}

	func subscribe(_ vmType: ViewModel.Type, handler: @escaping StorageSubscriptionHandler) {
		handler(viewModels, updatesForViewModels)
	}

	func save(models: [Decodable]) {
		savedModels.append(contentsOf: models)
	}

	func save(model: Decodable) {
		savedModels.append(model)
	}

	func deleteAll() {
		didDeleteAll = true
	}
}
