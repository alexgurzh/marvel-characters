//
//  UIImageView.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 09.04.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
	func setImage(by path: URL?) {
		kf.setImage(with: path)
	}
}
