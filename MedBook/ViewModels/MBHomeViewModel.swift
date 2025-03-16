//
//  MBHomeViewModel.swift
//  MedBook
//
//  Created by Pritesh Singh on 14/03/25.
//

import Foundation

protocol MBHomeViewModelProtocol: AnyObject {
    func onDataFetched(books: [MBBookListModel]?, error: String?)
}

class MBHomeViewModel {
    
    weak var delegate: MBHomeViewModelProtocol?
    
    var repository: MBDataRepository?
    
    var selectedSortOption = MBSortOptionModel(id: 1, title: MBConstants().Title)
    
    private var books: [MBBookListModel]? = []
    
    init(repo: MBDataRepository?) {
        self.repository = repo
    }
    
    func reset() {
        self.books = []
        (self.repository as? MBBooksListAPIRepository)?.reset()
    }
    
    func fetchData() {
        
        repository?.fetch({ result, error in
            
            if error == nil {
                guard let books = MBDataAdapter().getBooksData(result: result) else {
                    self.delegate?.onDataFetched(books: nil, error: nil)
                    return
                }
                
                let realmBooks = MBBookMarkDBHelper.shared.getAllBooks()
                
                let newBooks: [MBBookListModel] = books.map { book in
                    var updatedBook = book
                    if let savedBook = realmBooks.first(where: { $0.id == updatedBook.key }) {
                        updatedBook.isBookmarked = savedBook.isBookmarked
                    }
                    return updatedBook
                }
                
                self.books?.append(contentsOf: newBooks)
                self.sortBooks(by: self.selectedSortOption)
            } else {
                self.delegate?.onDataFetched(books: nil, error: error)
            }
        })
    }
    
    func sortBooks(by sortOption: MBSortOptionModel) {
        
        var sortedBooks: [MBBookListModel] = []
        
        guard let books = books else {
            self.delegate?.onDataFetched(books: books, error: nil)
            return
        }
        
        switch sortOption.title {
        case MBConstants().Title:
            sortedBooks = books.sorted { $0.title ?? "" < $1.title ?? "" }
        case MBConstants().Author:
            sortedBooks = books.sorted { $0.author ?? "" < $1.author ?? "" }
        case MBConstants().Hits:
            sortedBooks = books.sorted { $0.rating ?? "" > $1.rating ?? "" }
        default:
            break
        }
        
        self.books = []
        self.books = sortedBooks
        self.delegate?.onDataFetched(books: sortedBooks, error: nil)
    }
    
    func getSortModelOptions() -> [MBSortOptionModel] {
        
        var options = [MBSortOptionModel]()
        options.append(MBSortOptionModel(id: 1, title: MBConstants().Title))
        options.append(MBSortOptionModel(id: 2, title: MBConstants().Author))
        options.append(MBSortOptionModel(id: 3, title: MBConstants().Hits))
        return options
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
