//
//  MarvelContentSummaryEntity.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 07.04.2021.
//

import RealmSwift

@objcMembers
final class MarvelContentSummaryEntity: Object {
	dynamic var name: String = ""
	dynamic var resourceURI: String = ""
	dynamic var type: String = ""

	convenience init(model: MarvelContentSummary)  {
		self.init()
		name = model.name
		resourceURI = model.resourceURI
		type = model.type ?? ""
	}
}
