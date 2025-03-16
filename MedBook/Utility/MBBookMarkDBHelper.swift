//
//  MBBookMarkDBHelper.swift
//  MedBook
//
//  Created by Pritesh Singh on 15/03/25.
//

import Foundation
import RealmSwift

final class MBBookMarkDBHelper {
    
    private init() {}
    
    static let shared = MBBookMarkDBHelper()
    
    func saveBookDetail(book: MBBookListModel?) {
        
        if let dbModel = book?.toDBModel() {
            RealmManager().addData(object: dbModel)
        }
    }
    
    func getAllBooks() -> [MBBookListDBModel] {
        guard let results = RealmManager().getGenericObjectsFromDB(object: MBBookListDBModel.self) else {
            return []
        }
        return Array(results)
    }
    
    func getBookByID(id: String) -> MBBookListDBModel? {
        return RealmManager().getObjectsFromDB(object: MBBookListDBModel.self, primaryKey: id) as? MBBookListDBModel
    }
    
    func updateBookmarkStatus(for id: String, isBookmarked: Bool) {
        do {
            let realm = try Realm()
            guard let book = realm.object(ofType: MBBookListDBModel.self, forPrimaryKey: id) else { return }
            try realm.write {
                book.isBookmarked = isBookmarked
            }
        } catch { }
    }
    
    func getBookmarkedBooks() -> [MBBookListDBModel] {
        return RealmManager()
            .getGenericObjectsFromDB(object: MBBookListDBModel.self)?
            .filter("isBookmarked == true")
            .map { $0 } ?? []
    }
    
    func deleteBookByID(id: String) {
        RealmManager().deleteObjectByID(objectType: MBBookListDBModel.self, primaryKey: id)
    }
    
}
