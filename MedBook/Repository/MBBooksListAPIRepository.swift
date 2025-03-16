//
//  MBBooksListAPIRepository.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//

import Foundation

class MBBooksListAPIRepository: MBDataRepository {
    
    private var params: MBAPIRepositoryParam?
    private var pageIndex: Int = 0
    private var pageSize: Int = 10
    private var recordCount: Int?
    
    init(params: MBAPIRepositoryParam? = nil) {
        self.params = params
    }
    
    func fetch(_ completion: @escaping MBResponseCompletionHandler) {
        
        guard hasMoreData() else {
            completion(nil, "No more data to load.")
            return
        }
        
        let offSet = (pageIndex / pageSize) + 1
        
        let url = "https://openlibrary.org/search.json?title=\(self.params?.searchText ?? "")&limit= \(pageSize) &offset= \(offSet)"
        
        guard let _url = URL(string: url) else { return }
        
        HttpBasicService().getAPI(_url) {
            data, response, error in
            
            if error == nil, let _data = data {
                let formattedData = MBHelper.shared.getFormattedData(_data)
                
                self.pageIndex += self.pageSize
                self.recordCount = (self.recordCount ?? 0) + (MBDataAdapter().getBooksData(result: formattedData)?.count ?? 0)
                
                completion(formattedData, nil)
            }
            else {
                completion(nil, error.debugDescription)
            }
        }
    }
    
    
    private func hasMoreData() -> Bool {
        if let recordCount = self.recordCount, recordCount < pageSize {
            return false
        }
        return true
    }
    
    func reset() {
        pageIndex = 0
        recordCount = 0
    }
}
