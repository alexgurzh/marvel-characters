//
//  NavigationControllerSpy.swift
//  MarvelCharactersTests
//
//  Created by Alexander Gurzhiev on 10.04.2021.
//

import UIKit

final class NavigationControllerSpy: UINavigationController {
	var pushedViewController: UIViewController? = nil
	var didPop: Bool = false
	var didPopToRoot: Bool = false

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		pushedViewController = viewController
	}

	override func popViewController(animated: Bool) -> UIViewController? {
		didPop = true
		return nil
	}
	
	override func popToRootViewController(animated: Bool) -> [UIViewController]? {
		didPopToRoot = true
		return nil
	}
}
