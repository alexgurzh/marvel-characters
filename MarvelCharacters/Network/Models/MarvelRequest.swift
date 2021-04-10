//
//  MarvelRequest.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 04.04.2021.
//

import Foundation

struct MarvelRequest: Encodable {
	private let ts: Int
	private let apikey: String
	private let hash: String
	private let orderBy: String

	private let offset: Int
	private let limit: Int

	private let nameStartsWith: String?

	init(configuration: NetworkConfiguration, offset: Int, limit: Int = 20, search: String? = nil) {
		self.ts = Int(Date().timeIntervalSince1970)
		self.apikey = configuration.publicApiKey
		self.hash = "\(ts)\(configuration.privateApiKey)\(apikey)".md5
		orderBy = "name"
		self.offset = offset
		self.limit = limit
		nameStartsWith = search
	}
}
