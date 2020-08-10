//
//  Model.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/10.
//  Copyright © 2020 강희선. All rights reserved.
//

import Foundation

class Memo {
    var content: String
    var insertDate: Date
    
    init(content: String) {
        self.content = content
        insertDate = Date() //현재날짜
    }
    
    static var dummyMemoList = [
        Memo(content: "iOS"),
        Memo(content: "Swift"),
        Memo(content: "Exercise")
    ]
}
