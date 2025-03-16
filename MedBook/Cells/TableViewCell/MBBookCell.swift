//
//  MBBookCell.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//

import UIKit

class MBBookCell: UITableViewCell {
    
    weak var model: MBBookListModelCellProtocol?
    
    func getReusableIdentifier() -> String {
        return ""
    }
    
    func getNibName() -> String {
        return ""
    }
}
    
