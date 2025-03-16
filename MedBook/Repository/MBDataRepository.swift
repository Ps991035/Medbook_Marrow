//
//  MBDataRepository.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

typealias MBResponseCompletionHandler = (_ result: [AnyHashable:Any]?, _ error: String?) -> Void

protocol MBDataRepository {
    func fetch(_ completion: @escaping MBResponseCompletionHandler)
}
