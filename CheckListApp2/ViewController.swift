//
//  ViewController.swift
//  CheckListApp2
//
//  Created by apple on 2021/03/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    static var filterMemoData = [MemoModel]()
    let searchController = UISearchController(searchResultsController: nil)
    static var memoList = [MemoModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()

    }
    
    override func viewDidLoad() {

        createButton.layer.cornerRadius = 30
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createButton.clipsToBounds = true
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        
        myTableView.tableHeaderView = searchController.searchBar
        myTableView.register(MyMemoList.nib(), forCellReuseIdentifier: MyMemoList.identifier)
        
        
        super.viewDidLoad()
    }

    @IBAction func createMemoView(_ sender: Any) {
        if searchController.isActive {
            self.searchController.dismiss(animated: false) {
            }
        }
        guard let memoCreatVC = self.storyboard?.instantiateViewController(identifier: "MemoViewController") else { return }
        memoCreatVC.modalPresentationStyle = .fullScreen
        self.present(memoCreatVC, animated: true, completion: nil)
    }
    
    func updateMode(memoData: MemoModel, indexPath: Int?) {
        if searchController.isActive {
            self.searchController.dismiss(animated: false) {
            }
        }
        
        guard let memoCreatVC = self.storyboard?.instantiateViewController(identifier: "MemoViewController") as? MemoViewController else { return }
        memoCreatVC.modalPresentationStyle = .fullScreen
        memoCreatVC.updateData(contentData: memoData.content, title: memoData.memoTitle, indexPath: indexPath)
        self.present(memoCreatVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ViewController.memoList.count == 0 {
            tableView.setEmptyMessage("No Data")
        } else if isFiltering {
            return ViewController.filterMemoData.count != 0 ? ViewController.filterMemoData.count : noData()
        } else {
            tableView.restore()
            return ViewController.memoList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: MyMemoList.identifier, for: indexPath) as! MyMemoList
        let index: Int
        let memoData: MemoModel
        var titleText: String
        
        if isFiltering {
            index = (ViewController.filterMemoData.count-1) - indexPath.row
            memoData = ViewController.filterMemoData[index]
        } else {
            index = (ViewController.memoList.count-1) - indexPath.row
            memoData = ViewController.memoList[index]
        }
        titleText = memoData.memoTitle
        if titleText == "" {
            titleText = memoData.content
        }
        cell.title.text = titleText
        cell.date.text = memoData.dateString

        return cell
        
    }
    
    func noData() -> Int {
        self.myTableView.setEmptyMessage("No Data")
        return 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAtcion = UIContextualAction(style: .destructive, title: "삭제하기", handler: {(ac:UIContextualAction, view:UIView, suecess: (Bool) -> Void) in

            ViewController.memoList.remove(at: indexPath.row)
            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
        })

        return UISwipeActionsConfiguration(actions: [deleteAtcion])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index: Int
        
        if isFiltering {
            index = indexPath.row != 0 ? (ViewController.memoList.count-1) - indexPath.row : 0
        } else {
            index = indexPath.row != 0 ? (ViewController.filterMemoData.count-1) - indexPath.row : 0
        }
        updateMode(memoData: ViewController.memoList[index], indexPath: Optional(index))
    }
    
    func filterData(_ searchText: String) {
        ViewController.filterMemoData = ViewController.memoList.filter { $0.memoTitle.contains(searchText) }
        
        myTableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        filterData(searchBar.text!)
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = UIFont.boldSystemFont(ofSize: 30)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


