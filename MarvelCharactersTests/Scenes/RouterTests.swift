//
//  RouterTests.swift
//  MarvelCharactersTests
//
//  Created by Alexander Gurzhiev on 03.04.2021.
//

import XCTest
@testable import MarvelCharacters

class RouterTests: XCTestCase {
	private var sut: Router!
	private var navController: NavigationControllerSpy!

	override func setUp() {
		super.setUp()
		navController = NavigationControllerSpy()
		sut = Router(navigationController: navController)
	}

	override func tearDown() {
		sut = nil
		navController = nil
		super.tearDown()
	}

	func testOpenCharactersList() throws {
		// arrange & act
		sut.openCharactersList()

		// assert
		XCTAssertTrue(navController.pushedViewController is CharactersViewController)
	}

	func testOpenCharactersDetails() throws {
		// arrange
		let detailsModel = CharacterDetailsViewModel(id: 0, name: "test", avatar: nil, description: nil, contents: [])

		// act
		sut.openCharacterDetails(detailsModel)

		// assert
		XCTAssertTrue(navController.pushedViewController is CharacterDetailsViewController)
	}

	func testGoBack() throws {
		// arrange & act
		sut.goBack()

		// assert
		XCTAssertTrue(navController.didPop)
	}

	func testGoToMain() throws {
		// arrange & act
		sut.goToMain()

		// assert
		XCTAssertTrue(navController.didPopToRoot)
	}
}
