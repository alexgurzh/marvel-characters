//
//  MarvelAPIService.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 04.04.2021.
//

import Foundation
import Alamofire

final class MarvelAPIService {
	private let configuration: NetworkConfiguration
	private var pagination: (hasMore: Bool, offset: Int) = (true, 0)
	private var loadInProgress: Bool = false

	init(configuration: NetworkConfiguration = .Default) {
		self.configuration = configuration
	}

	private func buildRequest(_ entity: MarvelRequest, path: String, method: HTTPMethod) -> DataRequest {
		let fullPath = "\(configuration.basePath)\(path)"
		let parameters = encodeParameters(entity)
		return AF
			.request(fullPath, method: method, parameters: parameters)
			.cURLDescription { debugPrint($0) }
	}

	private func encodeParameters<Value>(_ value: Value) -> [String: Any] where Value: Encodable {
		guard let data = try? JSONEncoder().encode(value),
			  let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
			return [:]
		}
		return result
	}
}

extension MarvelAPIService: NetworkService {
	func load(search: String?, completion: @escaping RequestCompletion) {
		guard !loadInProgress else {
			return
		}
		guard pagination.hasMore else {
			completion(.failure(MarvelError.noMorePages))
			return
		}
		loadInProgress = true
		let entity = MarvelRequest(configuration: configuration, offset: pagination.offset, search: search)
		let request = buildRequest(entity, path: "v1/public/characters", method: .get)
		request.responseData { [weak self] dataResponse in
			switch dataResponse.result {
			case .success(let data):
				if let response: MarvelResponse = try? JSONDecoder().decode(MarvelResponse.self, from: data),
				   let responseData = response.data {
					self?.pagination = (responseData.hasMorePages, responseData.nextOffset)
					completion(.success(responseData))
				} else {
					completion(.failure(MarvelError.decodeError))
				}
			case .failure(let error):
				completion(.failure(error))
			}
			self?.loadInProgress = false
		}
	}

	func reset() {
		pagination = (true, 0)
		loadInProgress = false
	}
}
