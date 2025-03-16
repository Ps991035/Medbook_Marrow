//
//  MBBookSortCollectionViewCell.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//

import UIKit

class MBBookSortCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var uvBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.uvBackground.layer.cornerRadius = 8
        self.uvBackground.clipsToBounds = true
    }
    
    func setData(title: String?, isSelected: Bool) {
        
        self.lblTitle.text = title
        
        if isSelected {
            self.uvBackground.backgroundColor = .gray
        }else {
            self.uvBackground.backgroundColor = .clear
        }
    }

}
