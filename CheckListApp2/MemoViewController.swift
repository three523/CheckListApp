//
//  MemoViewController.swift
//  CheckListApp2
//
//  Created by apple on 2021/03/25.
//

import UIKit

class MemoViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var titleName: UITextField!
    @IBOutlet var content: UITextView!
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
        if memoData.content == "" && memoData.memoTitle == "" {
            
            self.dismiss(animated: true, completion: nil)
        } else {
            
            if mode == nil {                                        // mode는 새로 생성인지 업데이트를 위한건지 알기위한 변수
                ViewController.memoList.append(memoData)
            } else if isUpdate(memoData: memoData) {
                ViewController.memoList.remove(at: mode!)                         // 지우고 가장 최신데이터로 업데이트 시킨다
                memoData.updateTime()
                ViewController.memoList.append(memoData)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isUpdate(memoData: MemoModel) -> Bool {
        let afterData = ViewController.memoList
        return afterData[mode!].memoTitle != memoData.memoTitle || afterData[mode!].content != memoData.content
    }
}
