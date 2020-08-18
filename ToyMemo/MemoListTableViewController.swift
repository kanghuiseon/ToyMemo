//
//  MemoListTableViewController.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/10.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var token: NSObjectProtocol?
    // 옵저버 삭제
    deinit{
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 옵저버 실행코드는 한번만 실행하면되기때문에 보통 여기서 구현함
        // ui 업데이트 코드는 반드시 메인스레드에서 실행해야함
        // ios에서는 스레드를 직접 처리하지않고 dispatchqueue, operationqueue를 이용해서 처리함
        // using에서 전달한 클로저가 queue에서 실행됨.
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main, using: {
            [weak self] (noti) in
            self?.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//        print(#function)
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Memo.dummyMemoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let target = Memo.dummyMemoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.insertDate)
        return cell
    }
    

   
}
