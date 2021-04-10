//
//  CharacterViewModel.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 07.04.2021.
//

import Foundation

struct CharacterViewModel: ViewModel {
	private(set) var id: Int
	let name: String
	let avatar: URL?
}
