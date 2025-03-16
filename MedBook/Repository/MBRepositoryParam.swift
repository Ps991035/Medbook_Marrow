//
//  MBRepositoryParam.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

enum APIType {
    case CountryList
    case BooksList
}

struct MBAPIRepositoryParam {
    var searchText: String?
}
