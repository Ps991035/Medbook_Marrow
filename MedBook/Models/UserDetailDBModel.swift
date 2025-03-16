//
//  UserDetailDBModel.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation
import RealmSwift

class UserDetailDBModel: Object {
    
    @objc dynamic var email: String? = nil
    @objc dynamic var password: String? = nil
    @objc dynamic var country: String? = nil
    @objc dynamic var token: String? = nil
    
    override class func primaryKey() -> String? {
        return "email"
    }
    
}
