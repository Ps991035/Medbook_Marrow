//
//  MBDataAdapter.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class MBDataAdapter: MBAdapter {
    
    /**
     * @param result   List of Countries information
     *  This function set the Countries Data into a model which we are getting in dictionary format.
     */
    
    func getData(result: [AnyHashable : Any]?) -> [MBCountryListModel]? {
        
        guard let result = result else {
            return []
        }
        
        var countries = [MBCountryListModel]()
        let data = result[MBConstants().Data] as? [AnyHashable:Any]
        
        if let _keys = data?.keys {
            for key in _keys {
                let countryData = data?[key] as? [AnyHashable:Any] ?? [:]
                let country = countryData[MBConstants().Country] as? String
                let region = countryData[MBConstants().Region] as? String
                countries.append(MBCountryListModel(country: country,region: region))
                
            }
        }
        return countries
    }
    
    func getBooksData(result: [AnyHashable : Any]?) -> [MBBookListModel]? {
        
        var books = [MBBookListModel]()
        
        let docs = result?[MBConstants().Docs] as? [[AnyHashable: Any]]
        
        for doc in docs ?? [] {
            let title = doc[MBConstants().Title] as? String
            let authorName = (doc[MBConstants().AuthorName] as? [String])?.first
            let coverImage = doc[MBConstants().CoverImage] as? Int
            let ratings_average = doc[MBConstants().RatingAverage] as? String
            let ratings_count = doc[MBConstants().RatingsCount] as? Int
            let key = doc[MBConstants().key] as? String
            
            books.append(MBBookListModel(title: title, rating: ratings_average, ratingCount: ratings_count, author: authorName, coverImage: coverImage, key: key, isBookmarked: false))
        }
        return books
    }
}
