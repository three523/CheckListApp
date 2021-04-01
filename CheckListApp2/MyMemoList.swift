//
//  MyMemoList.swift
//  CheckListApp2
//
//  Created by apple on 2021/03/24.
//

import UIKit

class MyMemoList: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    static let identifier = "MemoCell"
    
    static func nib() -> UINib {
        UINib(nibName: "MyMemoList", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
