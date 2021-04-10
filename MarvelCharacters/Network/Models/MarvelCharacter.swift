//
//  MarvelCharacter.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 07.04.2021.
//

import Foundation

struct MarvelCharacter: Decodable {
	let id: Int
	let name: String
	let description: String
	let thumbnail: Image

	let comics: MarvelContentList?
	let stories: MarvelContentList?
	let events: MarvelContentList?
	let series: MarvelContentList?
}

struct Image: Decodable {
	let path: String
	let `extension`: String
}

struct MarvelContentList: Decodable {
	let available: Int?
	let returned: Int?
	let collectionURI: String?
	let items: [MarvelContentSummary]?
}

struct MarvelContentSummary: Decodable {
	let resourceURI: String
	let name: String
	let type: String?
}
