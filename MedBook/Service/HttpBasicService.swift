//
//  HttpBasicService.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class HttpBasicService: BasicService {
    
    func getAPI(_ url: URL,_ completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {
            data, response, error in
            completion(data, response, error)
            
        })
        session.resume()
    }
    
}
