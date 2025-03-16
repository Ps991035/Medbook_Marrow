//
//  MBFactory.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class MBFactory {
    
    var params: MBAPIRepositoryParam?
    
    init(params: MBAPIRepositoryParam?) {
        self.params = params
    }
    
    func getRepository(apiType: APIType?) -> MBDataRepository? {
        
        switch apiType {
            
        case .CountryList:
            return MBCountryListAPIRepository()
            
        case .BooksList:
            return MBBooksListAPIRepository(params: params)
            
        default:
            return nil
        }
    }
}

