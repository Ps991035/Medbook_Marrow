//
//  MBCountryListAPIRepository.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class MBCountryListAPIRepository: MBDataRepository {
    
    /**
     *  This function call the API and also format the json and send the completion of the List of the countries if error has not occured.
     *  IF error has come then in completion it will send the error message in completion
     */
    
    func fetch(_ completion: @escaping MBResponseCompletionHandler) {
        
        let url = "https://api.first.org/data/v1/countries"
        guard let _url = URL(string: url) else { return }
        
        HttpBasicService().getAPI(_url) {
            data, response, error in
            if error == nil, let _data = data {
                let formattedData = MBHelper.shared.getFormattedData(_data)
                completion(formattedData, nil)
            }
            else {
                completion(nil, error.debugDescription)
            }
        }
    }
}
