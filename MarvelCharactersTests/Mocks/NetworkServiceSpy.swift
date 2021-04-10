//
//  NetworkServiceSpy.swift
//  MarvelCharactersTests
//
//  Created by Alexander Gurzhiev on 10.04.2021.
//

@testable import MarvelCharacters

final class NetworkServiceSpy: NetworkService {
	var successResponse: MarvelResponse.DataContainer?
	var errorResponse: Error?
	var searchText: String?
	var didReset: Bool = false

	func load(search: String?, completion: @escaping RequestCompletion) {
		searchText = search
		if let successResponse = successResponse {
			completion(.success(successResponse))
		} else if let errorResponse = errorResponse {
			completion(.failure(errorResponse))
		}
	}

	func reset() {
		didReset = true
	}
}
