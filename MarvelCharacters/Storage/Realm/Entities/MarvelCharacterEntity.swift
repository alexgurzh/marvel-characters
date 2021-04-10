//
//  MarvelCharacterEntity.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 07.04.2021.
//

import Foundation
import RealmSwift

@objcMembers
final class MarvelCharacterEntity: Object {
	dynamic var id: Int = 0
	dynamic var name: String = ""
	dynamic var caption: String = ""
	dynamic var thumbnailUrlPath: String = ""
	dynamic var thumbnailExtension: String = ""
	var thumbnailUrl: URL? {
		URL(string: "\(thumbnailUrlPath).\(thumbnailExtension)")
	}

	let comics = List<MarvelContentSummaryEntity>()
	let stories = List<MarvelContentSummaryEntity>()
	let events = List<MarvelContentSummaryEntity>()
	let series = List<MarvelContentSummaryEntity>()

	override class func primaryKey() -> String? { "id" }

	convenience init(model: MarvelCharacter) {
		self.init()
		id = model.id
		name = model.name
		caption = model.description
		thumbnailUrlPath = model.thumbnail.path
		thumbnailExtension = model.thumbnail.extension
		model.comics?.items?.forEach {
			comics.append(MarvelContentSummaryEntity(model: $0))
		}
		model.stories?.items?.forEach {
			stories.append(MarvelContentSummaryEntity(model: $0))
		}
		model.events?.items?.forEach {
			events.append(MarvelContentSummaryEntity(model: $0))
		}
		model.series?.items?.forEach {
			series.append(MarvelContentSummaryEntity(model: $0))
		}
	}
}
