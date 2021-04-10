//
//  NetworkServiceProtocol.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 09.04.2021.
//

typealias RequestCompletion = (Result<MarvelResponse.DataContainer, Error>) -> Void

protocol NetworkServiceProtocol {
	func load(search: String?, completion: @escaping RequestCompletion)
	func reset()
}

struct NetworkConfiguration {
	let basePath: String
	let privateApiKey: String
	let publicApiKey: String

	static let Default: NetworkConfiguration = .init(
		basePath: "https://gateway.marvel.com/",
		privateApiKey: "dc113a08782d063879030a12b2ccbdf07a265ecd",
		publicApiKey: "0e175f4ddb41460ab0fa1e23ab442b45"
	)
}
