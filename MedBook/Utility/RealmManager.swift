//
//  RealmManager.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation
//import Realm
//import RealmSwift
//
//final class RealmManager {
//    
//    private var database: Realm?
//    private var realmValue: Results<UserDetailDBModel>?
//    
//    init() {
//        do {
//            database = try Realm()
//        }catch {}
//    }
//    
//    func addData(object: Object){
//        
//        do {
//            try database?.write {
//                database?.add(object, update: .all)
//            }
//        }catch {
//            debugPrint("Error is \(error)")
//        }
//    }
//    
//    func getObjectsFromDB(object: Object.Type) -> Results<Object>? {
//        if let results: Results<Object> = database?.objects(object.self) {
//            return results
//        }
//        return nil
//    }
//    
//    func getGenericObjectsFromDB<T: Object>(object: T.Type) -> Results<T>? {
//        return database?.objects(object.self)
//    }
//    
//    func getObjectsFromDB(object: Object.Type, primaryKey: String) -> Object? {
//        if let result: Object = database?.object(ofType: object, forPrimaryKey: primaryKey) {
//            return result
//        }
//        return nil
//    }
//    
//    func deleteObjectByID<T: Object>(objectType: T.Type, primaryKey: String) {
//        do {
//            if let objectToDelete = database?.object(ofType: objectType, forPrimaryKey: primaryKey) {
//                try database?.write {
//                    database?.delete(objectToDelete)
//                }
//            }
//        } catch { }
//    }
//}

import Foundation
import RealmSwift
import Security

final class RealmManager {
    
    private var database: Realm?
    
    init() {
        do {
            let config = Realm.Configuration(encryptionKey: getEncryptionKey())
            database = try Realm(configuration: config)
        } catch {}
    }
    
    private func getEncryptionKey() -> Data {
        let keychainKey = "com.yourapp.realm.encryptionKey"
        
        if let storedKey = getKeyFromKeychain(for: keychainKey) {
            return storedKey
        } else {
            let newKey = generateNewEncryptionKey()
            storeKeyInKeychain(newKey, for: keychainKey)
            return newKey
        }
    }
    
    private func generateNewEncryptionKey() -> Data {
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 64, $0.baseAddress!) }
        return key
    }
    
    private func storeKeyInKeychain(_ key: Data, for keychainKey: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: key
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getKeyFromKeychain(for keychainKey: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
    
    func addData(object: Object) {
        do {
            try database?.write {
                database?.add(object, update: .all)
            }
        } catch {
            debugPrint("Error adding object: \(error)")
        }
    }
    
    func getObjectsFromDB(object: Object.Type) -> Results<Object>? {
        if let results: Results<Object> = database?.objects(object.self) {
            return results
        }
        return nil
    }
    
    func getGenericObjectsFromDB<T: Object>(object: T.Type) -> Results<T>? {
        return database?.objects(object.self)
    }
    
    func getObjectsFromDB(object: Object.Type, primaryKey: String) -> Object? {
        if let result: Object = database?.object(ofType: object, forPrimaryKey: primaryKey) {
            return result
        }
        return nil
    }
    
    func getObjectByID<T: Object>(objectType: T.Type, primaryKey: String) -> T? {
        return database?.object(ofType: objectType, forPrimaryKey: primaryKey)
    }
    
    func deleteObjectByID<T: Object>(objectType: T.Type, primaryKey: String) {
        do {
            if let objectToDelete = database?.object(ofType: objectType, forPrimaryKey: primaryKey) {
                try database?.write {
                    database?.delete(objectToDelete)
                }
            }
        } catch {}
    }
}

