//
//  MarvelError.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 09.04.2021.
//

import Foundation

enum MarvelError: Error, LocalizedError {
	case decodeError
	case noMorePages

	var errorDescription: String? {
		switch self {
		case .decodeError:
			return "JSON decode error"
		case .noMorePages:
			return "No more pages"
		}
	}
}
