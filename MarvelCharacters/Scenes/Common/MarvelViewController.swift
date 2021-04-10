//
//  MarvelViewController.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 08.04.2021.
//

import UIKit

class MarvelViewController: UIViewController {
	let router: Router

	init(router: Router) {
		self.router = router
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
