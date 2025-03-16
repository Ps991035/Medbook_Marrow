//
//  MBBookListModelCell.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//

import Foundation
import UIKit

protocol MBBookListModelCellProtocol: AnyObject {
    func getCellReusableIdentifier() -> String
}

class MBBookListModelCell: MBBookListModelCellProtocol {
    
    var bookModel: MBBookListModel?
    
    func getCellReusableIdentifier() -> String {
        return "MBBookTableViewCell"
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://covers.openlibrary.org/b/id/\(self.bookModel?.coverImage ?? 0)-M.jpg") else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
