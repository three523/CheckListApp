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
    let persistenceManager = PersistenceManager.shared
    var filterMemo = Array<Memo>()
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func viewDidLoad() {

        createButtonDesign()
        myTableViewSetting()
        searchControllerSetting()
        
        super.viewDidLoad()
    }
    
    func createButtonDesign() {
        
        createButton.layer.cornerRadius = 30
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createButton.clipsToBounds = true
    }
    
    func myTableViewSetting() {
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableHeaderView = searchController.searchBar
        myTableView.register(MyMemoList.nib(), forCellReuseIdentifier: MyMemoList.identifier)
    }
    
    func searchControllerSetting() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
    }

    //MARK: MemoData Create
    @IBAction func createMemoView(_ sender: Any) {
        if searchController.isActive {
            self.searchController.dismiss(animated: false) {
            }
        }
        guard let memoCreatVC = self.storyboard?.instantiateViewController(identifier: "MemoViewController") as? MemoViewController else { return }
        memoCreatVC.modalPresentationStyle = .fullScreen
        self.present(memoCreatVC, animated: true, completion: { self.searchController.searchBar.text = ""})
    }
    
    //MARK: MemoData Update
    func updateMode(memoData: Memo, indexPath: Int?) {
        if searchController.isActive {
            self.searchController.dismiss(animated: false)
        }
        guard let memoCreatVC = self.storyboard?.instantiateViewController(identifier: "MemoViewController") as? MemoViewController else { return }
        memoCreatVC.modalPresentationStyle = .fullScreen
        memoCreatVC.updateData(contentData: memoData.content ?? "", title: memoData.title ?? "", indexPath: indexPath)
        self.present(memoCreatVC, animated: true, completion: { self.searchController.searchBar.text = ""
//            self.myTableView.reloadData()
        })
    }
    
    //MARK: TableView Cell Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memo = persistenceManager.fetch(request: Memo.fetchRequest())
        if memo.count == 0 {
            tableView.setEmptyMessage("No Data")
        } else if isFiltering {
            tableView.restore()
            return filterMemo.count != 0 ? filterMemo.count : noData()
        } else {
            tableView.restore()
            return memo.count
        }
        return 0
    }
    
    //MARK: TableView Create Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: MyMemoList.identifier, for: indexPath) as! MyMemoList
        let memoList = persistenceManager.fetch(request: Memo.fetchRequest())
        let index: Int
        let memoDatas: Memo
        var titleText: String
        
        if isFiltering {
            index = (filterMemo.count-1) - indexPath.row
            memoDatas = filterMemo[index]
        } else {
            index = (memoList.count-1) - indexPath.row
            memoDatas = memoList[index]
        }
        titleText = memoDatas.title ?? ""
        if titleText == "" {
            titleText = memoDatas.content ?? ""
        }
        
        cell.title.text = titleText
        cell.date.text = memoDatas.date

        return cell
        
    }
    
    func noData() -> Int {
        self.myTableView.setEmptyMessage("No Data")
        return 0
    }
    
    //MARK: TableView Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let memo = persistenceManager.fetch(request: Memo.fetchRequest())
        let deleteAtcion = UIContextualAction(style: .destructive, title: "삭제하기", handler: {(ac:UIContextualAction, view:UIView, suecess: (Bool) -> Void) in
            var index: Int
            print(memo)
            if self.isFiltering {
                index = (self.filterMemo.count-1) - indexPath.row
                self.filterMemo.remove(at: index)
                self.persistenceManager.delete(object: memo[index])
            } else {
                index = (memo.count-1) - indexPath.row
                self.persistenceManager.delete(object: memo[index])
            }
            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
        })

        return UISwipeActionsConfiguration(actions: [deleteAtcion])
    }
    
    //MARK: TableView Cell Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index: Int
        let memo = persistenceManager.fetch(request: Memo.fetchRequest())
        
        if isFiltering {
            index = (filterMemo.count-1) - indexPath.row
            updateMode(memoData: filterMemo[index], indexPath: Optional(index))
        } else {
            index = (memo.count-1) - indexPath.row
            updateMode(memoData: memo[index], indexPath: Optional(index))
        }
        
        
    }
    
    //MARK: SearchFunctions
    func filterData(_ searchText: String) {
        let memo = persistenceManager.fetch(request: Memo.fetchRequest())
        filterMemo = memo.filter { ($0.title?.contains(searchText) ?? false) }

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

//MARK: TableView No Data
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


