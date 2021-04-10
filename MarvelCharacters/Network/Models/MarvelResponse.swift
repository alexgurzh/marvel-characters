//
//  MarvelResponse.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 04.04.2021.
//

import Foundation

struct MarvelResponse: Decodable {
	let status: String?
	let message: String?
	let data: DataContainer?

	struct DataContainer: Decodable {
		private let offset: Int
		private let limit: Int
		let total: Int
		let count: Int
		let results: [MarvelCharacter]

		init(
			offset: Int = 0,
			limit: Int = 0,
			total: Int = 0,
			count: Int = 0,
			results: [MarvelCharacter]
		) {
			self.offset = offset
			self.limit = limit
			self.total = total
			self.count = count
			self.results = results
		}

		var hasMorePages: Bool {
			return total - (offset + limit) > 0
		}

		var nextOffset: Int {
			return hasMorePages ? offset + limit : offset
		}
	}
}
