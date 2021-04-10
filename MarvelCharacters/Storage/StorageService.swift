//
//  StorageService.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 07.04.2021.
//

protocol ViewModel {
	var id: Int { get }
}

protocol StorageService {
	func fetch(_ type: ViewModel.Type, by id: Int) -> ViewModel?
	func subscribe(_ type: ViewModel.Type, handler: @escaping StorageSubscriptionHandler)
	func save(models: [Decodable])
	func save(model: Decodable)
	func deleteAll()
}

typealias StorageSubscriptionHandler = ([ViewModel], [DataUpdate]) -> Void

struct DataUpdate {
	let indexes: [Int]
	let action: Action
	enum Action {
		case reload
		case delete
		case insert
	}
}
