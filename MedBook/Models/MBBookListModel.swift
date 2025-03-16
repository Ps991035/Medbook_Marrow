//
//  MBBookListModel.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//


import Foundation
import RealmSwift

struct MBBookListModel: Codable {
    var title: String?
    var rating: String?
    var ratingCount: Int?
    var author: String?
    var coverImage: Int?
    var key: String?
    var isBookmarked: Bool = false
}

extension MBBookListModel {
    func toDBModel() -> MBBookListDBModel {
        let dbModel = MBBookListDBModel()
        dbModel.id = key ?? ""
        dbModel.title = title ?? ""
        dbModel.rating = rating ?? ""
        dbModel.ratingCount = ratingCount ?? 0
        dbModel.author = author ?? ""
        dbModel.coverImage = coverImage ?? 0
        return dbModel
    }
}


class MBBookListDBModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String = ""
    @Persisted var rating: String = ""
    @Persisted var ratingCount: Int = 0
    @Persisted var author: String = ""
    @Persisted var coverImage: Int = 0
    @Persisted var isBookmarked: Bool = false
}

extension MBBookListDBModel {
    func toModel() -> MBBookListModel {
        return MBBookListModel(title: title, rating: rating, ratingCount: ratingCount, author: author, coverImage: coverImage, key: id)
    }
}
