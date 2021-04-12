//
//  CharactersInteractorTests.swift
//  MarvelCharactersTests
//
//  Created by Alexander Gurzhiev on 10.04.2021.
//

import XCTest
@testable import MarvelCharacters

class CharactersInteractorTests: XCTestCase {
	private var sut: CharactersInteractor!
	private var networkService: NetworkServiceSpy!
	private var storageService: StorageServiceSpy!

	override func setUp() {
		super.setUp()
		storageService = StorageServiceSpy()
		networkService = NetworkServiceSpy()
		sut = CharactersInteractor(networkService: networkService, storageService: storageService)
	}

	override func tearDown() {
		sut = nil
		networkService = nil
		storageService = nil
		super.tearDown()
	}

	func testLoadFromStart() {
		// arrange & act
		sut.load(search: nil, fromStart: true)

		// assert
		XCTAssertTrue(storageService.savedModels.isEmpty)
		XCTAssertTrue(networkService.didReset)
		XCTAssertNil(networkService.searchText)
	}

	func testLoadSearch() {
		// arrange
		let searchText = "test search"

		// act
		sut.load(search: searchText, fromStart: false)

		// assert
		XCTAssertTrue(storageService.savedModels.isEmpty)
		XCTAssertFalse(networkService.didReset)
		XCTAssertEqual(networkService.searchText, searchText)
	}

	func testLoadSusccess() {
		// arrange
		let models: [MarvelCharacter] = [
			.init(id: 0, name: "test0", description: "",
				  thumbnail: Image(path: "", extension: ""),
				  comics: nil, stories: nil, events: nil, series: nil),
			.init(id: 1, name: "test1", description: "",
				  thumbnail: Image(path: "", extension: ""),
				  comics: nil, stories: nil, events: nil, series: nil)
		]
		networkService.successResponse = .init(offset: 0, limit: 1, total: 1, count: 1, results: models)
		let expectation = XCTestExpectation()

		// act
		sut.load(search: nil, fromStart: false) {
			expectation.fulfill()
		}

		// assert
		wait(for: [expectation], timeout: 0.1)
		let savedModels: [MarvelCharacter] = self.storageService.savedModels.compactMap { $0 as? MarvelCharacter }
		XCTAssertEqual(savedModels.count, models.count)
		for expectModel in models {
			XCTAssertTrue(savedModels.contains(where: { $0.id == expectModel.id && $0.name == expectModel.name }))
		}
		XCTAssertFalse(self.networkService.didReset)
		XCTAssertNil(self.networkService.searchText)
	}

	func testLoadFailure() {
		// arrange
		let error = MarvelError.decodeError
		networkService.errorResponse = error
		let expectation = XCTestExpectation()

		// act
		sut.load(search: nil, fromStart: false) {
			expectation.fulfill()
		}

		// assert
		wait(for: [expectation], timeout: 0.1)
		XCTAssertTrue(self.storageService.savedModels.isEmpty)
		XCTAssertFalse(self.networkService.didReset)
		XCTAssertNil(self.networkService.searchText)
	}

	func testGetCharacterDetails() {
		// arrange
		let expectViewModel = CharacterDetailsViewModel(id: 1, name: "test", avatar: nil, description: nil, contents: [])
		storageService.viewModels.append(expectViewModel)

		// act
		let viewModel = sut.getCharacterDetails(by: 0)

		// assert
		XCTAssertEqual(expectViewModel.id, viewModel?.id)
		XCTAssertEqual(expectViewModel.name, viewModel?.name)
	}

	func testGetCharacterDetailsIncorrectType() {
		// arrange
		storageService.viewModels.append(CharacterViewModel(id: 1, name: "test", avatar: nil))

		// act
		let viewModel = sut.getCharacterDetails(by: 0)

		// assert
		XCTAssertNil(viewModel)
	}

	// TODO: Test subscribtions
}
