//
//  MBHomeViewController.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation
import UIKit

class MBHomeViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblMedbook: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var uvSort: UIView!
    @IBOutlet weak var cvSort: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tvBooks: UITableView!
    
    private lazy var viewModel = MBHomeViewModel(repo: nil)
    private var books: [MBBookListModel]?
    private var debounceWorkItem: DispatchWorkItem?
    private var selectedSortOption = MBSortOptionModel(id: 1, title: "Title")
    private let footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    /**
     *  This class is HomeView. User can Logout from here. If user tap on Logout then they will be redirected to LandingView.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.uvSort.isHidden = true
        self.setupCollectionView()
        self.viewModel.delegate = self
        self.searchBar.placeholder = "Search for books"
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupCollectionView() {
        self.cvSort.delegate = self
        self.cvSort.dataSource = self
        self.cvSort.register(UINib(nibName: "MBBookSortCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MBBookSortCollectionViewCell")
    }
    
    private func setupTableView(){
        self.tvBooks.delegate = self
        self.tvBooks.dataSource = self
        self.tvBooks.tableFooterView = footerSpinner
        self.viewModel.getBookCells()?.forEach({ bookCell in
            self.tvBooks.register(UINib(nibName: bookCell.getCellReusableIdentifier(), bundle: nil), forCellReuseIdentifier: bookCell.getCellReusableIdentifier())
        })
    }
    
    private func setupUI() {
        
        self.contentView.backgroundColor = MBUtility.hexStringToUIColor(hex: "#FAFAFA")
        self.setupLabelUI()
    }
    
    private func setupLabelUI(){
        self.lblMedbook.text = MBConstants().MedBook
        self.lblDescription.text = MBConstants().Which_Topic_Interests_You_Today
        self.lblDescription.textColor = UIColor.black.withAlphaComponent(0.7)
        self.lblMedbook.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self.lblDescription.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        if let vc = UIStoryboard(name: MBConstants().Main, bundle: nil).instantiateViewController(withIdentifier: MBConstants().MBLandingViewController) as? MBLandingViewController {
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }
    
    
    @IBAction func btnBookmark(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MBBookMarkViewController") as? MBBookMarkViewController {
            vc.navigationItem.title = "Bookmarks"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func initializeAndfetchData(text: String) {
        let param = MBAPIRepositoryParam(searchText: text)
        let repo = MBBooksListAPIRepository(params: param)
        viewModel.reset()
        viewModel.repository = repo
        self.showLoader()
        viewModel.fetchData()
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.cvSort.reloadData()
        }
    }
}

extension MBHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getSortModelOptions().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MBBookSortCollectionViewCell", for: indexPath) as? MBBookSortCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(title: self.viewModel.getSortModelOptions()[indexPath.row].title, isSelected: self.viewModel.getSortModelOptions()[indexPath.row].id == self.selectedSortOption.id)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSortOption = self.viewModel.getSortModelOptions()[indexPath.row]
        self.reloadCollectionView()
        self.viewModel.selectedSortOption = self.selectedSortOption
        self.viewModel.sortBooks(by: self.selectedSortOption)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
    
}

extension MBHomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        debounceWorkItem?.cancel()
        
        if text.count >= 3 {
            let workItem = DispatchWorkItem { [weak self] in
                self?.initializeAndfetchData(text: text)
            }
            debounceWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        }
    }
}


extension MBHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = self.viewModel.getBookCells()?[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: book?.getCellReusableIdentifier() ?? "", for: indexPath) as? MBBookTableViewCell {
            cell.model = book
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let book = books?[indexPath.row] else { return nil }
        
        let dbHelper = MBBookMarkDBHelper.shared
        let existingBook = dbHelper.getBookByID(id: book.key ?? "")
        let isBookmarked = existingBook != nil
        
        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            if isBookmarked {
                dbHelper.deleteBookByID(id: book.key ?? "")
            } else {
                dbHelper.saveBookDetail(book: book)
            }
            
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            completion(true)
        }
        
        let iconName = isBookmarked ? "bookmark.fill" : "bookmark"
        if let image = UIImage(systemName: iconName)?.withTintColor(isBookmarked ? .green : .gray, renderingMode: .alwaysOriginal) {
            bookmarkAction.image = image
        }
        bookmarkAction.backgroundColor = UIColor.clear
        
        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let totalBooks = self.books?.count ?? 0
        if indexPath.row == totalBooks - 2 {
            footerSpinner.startAnimating()
            viewModel.fetchData()
        }
    }
    
}

extension MBHomeViewController: MBHomeViewModelProtocol {
    
    func onDataFetched(books: [MBBookListModel]?, error: String?) {
        
        DispatchQueue.main.async {
            self.hideLoader()
            self.footerSpinner.stopAnimating()
        }
        
        if let error = error {
            DispatchQueue.main.async {
                self.showToast(message: error)
            }
        }else if let books = books {
            self.books = books
            DispatchQueue.main.async {
                self.uvSort.isHidden = false
                self.setupTableView()
                self.tvBooks.reloadData()
            }
        }
    }
}
