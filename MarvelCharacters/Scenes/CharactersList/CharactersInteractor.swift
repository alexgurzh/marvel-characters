//
//  CharactersInteractor.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 08.04.2021.
//

import Foundation

struct CharactersInteractor {
	private let networkService: NetworkService = MarvelAPIService()
	private let storageService: StorageService = RealmService()

	func load(search: String? = nil, fromStart: Bool = false, completion: (() -> Void)? = nil) {
		if fromStart {
			networkService.reset()
		}
		networkService.load(search: search) { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					storageService.save(models: response.results)
				case .failure(let error):
					debugPrint(error.localizedDescription)
				}
				completion?()
			}
		}
	}

	func getCharacterDetails(by id: Int) -> CharacterDetailsViewModel? {
		storageService.fetch(CharacterDetailsViewModel.self, by: id) as? CharacterDetailsViewModel
	}

	func subscribe(handler: @escaping StorageSubscriptionHandler) {
		storageService.subscribe(CharacterViewModel.self, handler: handler)
	}
}
