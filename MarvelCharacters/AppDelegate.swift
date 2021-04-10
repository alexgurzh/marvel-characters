//
//  AppDelegate.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 03.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var router: Router?
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let navigationController = UINavigationController()
		navigationController.navigationBar.tintColor = UIColor.marvelRed
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController.navigationBar.shadowImage = UIImage()
		router = Router(navigationController: navigationController)

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		
		return true
	}
}
