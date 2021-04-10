//
//  Router.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 08.04.2021.
//

import UIKit

final class Router {
	private let navigationController: UINavigationController
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		openCharactersList()
	}

	func openCharactersList() {
		let controller = CharactersViewController(router: self)
		navigationController.pushViewController(controller, animated: true)
	}

	func openCharacterDetails(_ model: CharacterDetailsViewModel) {
		let controller = CharacterDetailsViewController(router: self, model: model)
		navigationController.pushViewController(controller, animated: true)
	}

	func goBack() {
		navigationController.popViewController(animated: true)
	}

	func goToMain() {
		navigationController.popToRootViewController(animated: true)
	}
}
