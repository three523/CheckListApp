//
//  MemoModel.swift
//  CheckListApp2
//
//  Created by apple on 2021/03/25.
//

import Foundation

class MemoModel {
    var memoTitle: String
    var content: String
    var dateString = ""
    let dataFormater = DateFormatter()

    
    init(memoTitle: String, content: String) {
        self.memoTitle = memoTitle
        self.content = content
        dataFormater.dateFormat = "yyyy-MM-dd HH:mm"
        dateString = dataFormater.string(from: Date())
    }
    
    func update(memoTitle: String, content: String) {
        self.memoTitle = memoTitle
        self.content = content
        dateString = dataFormater.string(from: Date())
    }
    
}
