//
//  MBDBHelper.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

final class MBDBHelper {
    
    private init() {}
    
    static let shared = MBDBHelper()
    
    func saveUserDetail(userDetail: UserDetail?) {
        
        let realmManager = RealmManager()
        let userDBModel = UserDetailDBModel()
        
        userDBModel.email = userDetail?.email
        userDBModel.password = userDetail?.password
        userDBModel.token = userDetail?.token
        userDBModel.country = userDetail?.country
        realmManager.addData(object: userDBModel)
    }
    
    func getUserDetailDBModel() -> UserDetailDBModel? {
        guard let model = RealmManager().getObjectsFromDB(object: UserDetailDBModel.self) else {
            return nil
        }
        return model.first as? UserDetailDBModel
    }
    
    func getUserDetailDBModel(primaryKey: String?) -> UserDetailDBModel? {
        guard let model = RealmManager().getObjectsFromDB(object: UserDetailDBModel.self, primaryKey: primaryKey ?? "") else {
            return nil
        }
        return model as? UserDetailDBModel
    }
    
}
