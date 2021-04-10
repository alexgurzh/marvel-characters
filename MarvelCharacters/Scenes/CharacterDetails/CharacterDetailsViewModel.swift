//
//  CharacterDetailsViewModel.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 09.04.2021.
//

import Foundation

struct CharacterDetailsViewModel: ViewModel {
	private(set) var id: Int
	let name: String
	let avatar: URL?
	let description: String?
	let contents: [ContentList]

	struct ContentList {
		let name: String
		let list: [String]
	}
}
