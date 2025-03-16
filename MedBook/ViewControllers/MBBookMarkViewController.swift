//
//  MBBookMarkViewController.swift
//  MedBook
//
//  Created by Pritesh Singh on 15/03/25.
//

import Foundation
import UIKit

class MBBookMarkViewController: UIViewController {

    @IBOutlet weak var tvBook: UITableView!
    
    private var books: [MBBookListModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvBook.delegate = self
        self.tvBook.dataSource = self
        self.navigationController?.navigationBar.isHidden = false
        self.setData()
    }
    
    private func setData() {
        let books = MBBookMarkDBHelper.shared.getAllBooks()
        self.books = []
        for book in books {
            self.books?.append(book.toModel())
        }
        
        self.getBookCells()?.forEach({ bookCell in
            self.tvBook.register(UINib(nibName: bookCell.getCellReusableIdentifier(), bundle: nil), forCellReuseIdentifier: bookCell.getCellReusableIdentifier())
        })
    }
    
    private func reloadData() {
        setData()
        DispatchQueue.main.async {
            self.tvBook.reloadData()
        }
    }
    
    func getBookCells() -> [MBBookListModelCellProtocol]? {
        var cells = [MBBookListModelCellProtocol]()
        for book in books ?? [] {
            let cell = MBBookListModelCell()
            cell.bookModel = book
            cells.append(cell)
        }
        return cells
    }
    
}

extension MBBookMarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = self.getBookCells()?[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: book?.getCellReusableIdentifier() ?? "", for: indexPath) as? MBBookTableViewCell {
            cell.model = book
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let book = books?[indexPath.row] else { return nil }
        let dbHelper = MBBookMarkDBHelper.shared
        
        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            dbHelper.deleteBookByID(id: book.key ?? "")
            self.reloadData()
            
            completion(true)
        }
        
        if let image = UIImage(systemName: "bookmark.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal) {
            bookmarkAction.image = image
        }
        bookmarkAction.backgroundColor = UIColor.clear
        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }

}
