//
//  RealmService.swift
//  MarvelCharacters
//
//  Created by Alexander Gurzhiev on 03.04.2021.
//

import RealmSwift

final class RealmService {
	private let realm = try! Realm()
	private var notificationTokens: [NotificationToken] = []
}

extension RealmService: StorageService {
	func fetch(_ vmType: ViewModel.Type, by id: Int) -> ViewModel? {
		switch vmType {
		case is CharacterViewModel.Type, is CharacterDetailsViewModel.Type:
			guard let entity = realm.objects(MarvelCharacterEntity.self).filter("id == \(id)").first else {
				return nil
			}
			return characterViewModel(vmType, from: entity)
		default:
			fatalError("Unknown ViewModel.Type")
		}
	}

	func subscribe(_ vmType: ViewModel.Type, handler: @escaping StorageSubscriptionHandler) {
		switch vmType {
		case is CharacterViewModel.Type:
			let token = subscribeCharacters(handler: handler)
			notificationTokens.append(token)
		default:
			fatalError("Unknown ViewModel.Type")
		}
	}

	func save(models: [Decodable]) {
		models.forEach { self.save(model: $0) }
	}

	func save(model: Decodable) {
		switch model {
		case let charachterModel as MarvelCharacter:
			realm.beginWrite()
			let entity = MarvelCharacterEntity(model: charachterModel)
			realm.add(entity, update: .all)
			try? realm.commitWrite()
		default:
			break
		}
	}

	func deleteAll() {
		realm.beginWrite()
		realm.deleteAll()
		try? realm.commitWrite()
	}
}

// MARK: - Characters
extension RealmService {
	private func characterViewModel(_ type: ViewModel.Type, from entity: MarvelCharacterEntity) -> ViewModel {
		switch type {
		case is CharacterViewModel.Type:
			return CharacterViewModel(id: entity.id, name: entity.name, avatar: entity.thumbnailUrl)
		case is CharacterDetailsViewModel.Type:
			let contents: [CharacterDetailsViewModel.ContentList] = [
				.init(name: "Comics", list: entity.comics.map { $0.name }),
				.init(name: "Stories", list: entity.stories.map { $0.name }),
				.init(name: "Events", list: entity.events.map { $0.name }),
				.init(name: "Series", list: entity.series.map { $0.name })
			].filter { $0.list.count > 0 }
			return CharacterDetailsViewModel(id: entity.id,
											 name: entity.name,
											 avatar: entity.thumbnailUrl,
											 description: entity.caption.isEmpty ? nil : entity.caption,
											 contents: contents)
		default:
			fatalError("Unknown ViewModel.Type")
		}
	}

	func subscribeCharacters(handler: @escaping StorageSubscriptionHandler) -> NotificationToken {
		realm
			.objects(MarvelCharacterEntity.self)
			.sorted (byKeyPath: "name", ascending: true)
			.observe { changes in
			switch changes {
			case .initial(let items):
				let viewModels: [ViewModel] = Array(items).map { self.characterViewModel(CharacterViewModel.self, from: $0) }
				handler(viewModels, [DataUpdate(indexes: (0..<viewModels.count).map { $0 }, action: .insert)])
			case .update(let items, let deletions, let insertions, let modifications):
				let viewModels: [ViewModel] = Array(items).map { self.characterViewModel(CharacterViewModel.self, from: $0) }
				let updates: [DataUpdate] = [
					.init(indexes: deletions, action: .delete),
					.init(indexes: insertions, action: .insert),
					.init(indexes: modifications, action: .reload)
				]
				handler(viewModels, updates)
			case .error(let error):
				fatalError("\(error)")
			}
		}
	}
}
