//
//  BasicService.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

protocol BasicService {
     func getAPI(_ url: URL,_ completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
}
