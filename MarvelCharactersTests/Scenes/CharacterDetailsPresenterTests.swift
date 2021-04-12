//
//  CharacterDetailsPresenterTests.swift
//  MarvelCharactersTests
//
//  Created by Alexander Gurzhiev on 10.04.2021.
//

import XCTest
@testable import MarvelCharacters

class CharacterDetailsPresenterTests: XCTestCase {
	func testPresenter() {
		// arrange
		let viewModel = CharacterDetailsViewModel(id: 1,
												  name: "Name",
												  avatar: nil,
												  description: "description",
												  contents: [
			.init(name: "list0", list: ["item0", "item1", "item2", "item3"]),
			.init(name: "list1", list: ["item0", "item1", "item2"]),
			.init(name: "list2", list: ["item0", "item1"])
		])
		let expectedRowsForSections = [1, 4, 3, 2]
		let expectedSectionTitles = ["Description", "list0", "list1", "list2"]
		let sut = CharacterDetailsPresenter(model: viewModel)

		// act
		let sections = sut.sectionsCount
		let rowsForSections = (0...3).map { sut.rowsCount(for: $0) }
		let sectionTitles = (0...3).map { sut.sectionTitle(for: $0) }
		let rowText = sut.rowText(for: IndexPath(row: 1, section: 1))

		// assert
		XCTAssertEqual(sections, 4)
		XCTAssertEqual(rowsForSections, expectedRowsForSections)
		XCTAssertEqual(sectionTitles, expectedSectionTitles)
		XCTAssertEqual(rowText, "item1")
	}

	func testPresenterEmpty() {
		// arrange
		let viewModel = CharacterDetailsViewModel(id: 2,
												  name: "Name",
												  avatar: nil,
												  description: nil,
												  contents: [])
		let sut = CharacterDetailsPresenter(model: viewModel)

		// act
		let sections = sut.sectionsCount
		let rowsForSection = sut.rowsCount(for: 0)
		let sectionTitle = sut.sectionTitle(for: 0)

		// assert
		XCTAssertEqual(sections, 1)
		XCTAssertEqual(rowsForSection, 0)
		XCTAssertNil(sectionTitle)
	}
}
