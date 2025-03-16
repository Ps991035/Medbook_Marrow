//
//  MBAdapter.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

protocol MBAdapter {
    func getData(result: [AnyHashable:Any]?) -> [MBCountryListModel]?
}
