//
//  MemoViewController.swift
//  CheckListApp2
//
//  Created by apple on 2021/03/25.
//

import UIKit
import CoreData

class MemoViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var titleName: UITextField!
    @IBOutlet var content: UITextView!
    let persistenceManager = PersistenceManager.shared
    var mode: Int?
    var titleText = ""
    var contentText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleName.text = titleText
        self.content.text = contentText
    }
    func updateData(contentData: String, title:String, indexPath: Int?) {
        self.titleText = title
        self.contentText = contentData
        self.mode = indexPath
    }
    
    @IBAction func createMemo(_ sender: Any) {
        
        let memoData = MemoModel(memoTitle: titleName.text ?? "", content: content.text ?? "")
        let persistenceManager = PersistenceManager.shared
        
        if memoData.content == "" && memoData.memoTitle == "" {
            
            self.dismiss(animated: true, completion: nil)
        } else {
            
            if mode == nil {                                        // mode는 새로 생성인지 업데이트를 위한건지 알기위한 변수
                persistenceManager.insertMemo(memo: memoData)
            } else if isUpdate(memoData: memoData) {
                let memoList = persistenceManager.fetch(request: Memo.fetchRequest())
                
                persistenceManager.delete(object: memoList[mode!])
                memoData.updateTime()
                persistenceManager.insertMemo(memo: memoData)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isUpdate(memoData: MemoModel) -> Bool {
        let afterData = persistenceManager.fetch(request: Memo.fetchRequest())
        return afterData[mode!].title != memoData.memoTitle || afterData[mode!].content != memoData.content
    }
}
