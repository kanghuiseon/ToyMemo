//
//  ComposeViewController.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/17.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet var memoTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else{
            alert(message: "메모를 입력하세요")
            return
        }
        //제대로 메모가 쓰여있다면 guard문 아래로 실행됨
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        //방송국에서 브로드캐스팅하는것과 같다.
        //앱을 구성하는 모든 객체로 전달됨.
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}

extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
