//
//  MBBookTableViewCell.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//

import UIKit

class MBBookTableViewCell: MBBookCell {
    
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var model: MBBookListModelCellProtocol? {
        didSet {
            setData(model: model)
        }
    }
    
    override func awakeFromNib() {
        self.imgBook.layer.cornerRadius = 8
        self.imgBook.clipsToBounds = true
    }
    
    func setData(model: MBBookListModelCellProtocol?) {
        
        if let model = model as? MBBookListModelCell {
            self.lblTitle.text = model.bookModel?.title
            self.lblAuthor.text = model.bookModel?.author
            self.activityIndicator.startAnimating()
            self.activityIndicator.hidesWhenStopped = true
            model.loadImage(completion: { image in
                self.activityIndicator.stopAnimating()
                self.imgBook.image = image
            })
        }
    }
    
}
